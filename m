Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbZAGHnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbZAGHnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 02:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZAGHnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 02:43:11 -0500
Received: from phunq.net ([64.81.85.152]:40956 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751477AbZAGHnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 02:43:09 -0500
From: Daniel Phillips <phillips@phunq.net>
To: tux3@tux3.org
Subject: Tux3 Report: Structure of Tux3, Revisited
Date: Tue, 6 Jan 2009 23:43:06 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <200808112240.05975.phillips@phunq.net>
In-Reply-To: <200808112240.05975.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901062343.07114.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tux3 has grown simpler as it has aged.  Back in august when Tux3 was two 
weeks old, I described what seemed to be a fairly simple filesystem 
structure:

   http://kerneltrap.org/Linux/Tux3_Hierarchical_Structure

It turned out that a lot of fluff could still be cut.  The volume table 
was dropped for reasons I will get into below, and two internal 
structures, the version table and allocation bitmap, were recast as 
normal files.  We now have:

Superblock
   Inode table node*
      Inode table leaf*
         Inode*
            Inode attribute*!
            Data btree attribute
               Data btree node*
                  Data btree leaf*
                     Extent*!

Versioned elements are marked by !, repeated elements by *.

Now Tux3 is just a btree of btrees, an inode table btree from which file 
btrees descend.  Here it is in pictures, courtesy of Hirofumi Ogawa's 
brilliant graphical Tux3 structure dumper:

   http://tux3.org/images/tux3.structure.png
   http://tux3.org/images/tux3.structure.svg

The only structural elaborations still due to arrive are the log chain 
for atomic commit and "metablocks" into which frequently updated 
superblock fields will be moved, giving a form that is likely to serve 
well for a long time:

Superblock
   Metablock*
      log chain => log block => log block...
      Inode table node*
         Inode table leaf*
            Inode*
               Inode attribute*!
               Data btree attribute
                  Data btree node*
                     Data btree leaf*
                        Extent*!

To be sure, one could simplify even further by having just a single 
btree that includes file data in a single unified key space as Hammer 
does.  But the btree of btrees arrangement maps better to Linux's cache 
design: we cache inodes, so file operations normally deal with a very 
shallow btree referenced by a cached inode instead of a btree deep 
enough to map every object on an entire volume.  We are also able to 
use smaller btree keys for both inode table and files, making the 
btrees shallower yet.  So to me, what we have arrived at feels like the 
correct balance of "as simple as possible, but no simpler".

We now use regular files to represent a number of structural elements:

  * Allocation map
  * Version table
  * Atime table
  * Xattr atom table

Regular files have a number of benefits of "through coded" filesystem 
structures, including no special purpose code to write and maintain, 
cache index tree maintained by the VFS, no special allocation handling, 
no extra filesystem checking and less to worry about when we get to 
fancy things like filesystem shrinking.

Using a regular file as the allocation map seemed kind of unusual at 
first, but now seems completely natural.  Recursions came up, but they 
would also have come up if the allocation map were a separate 
structure.  Any allocation map that is itself dynamically allocated 
will have allocation recursions.  We use cache and logging techniques
to solve these, that are also needed for atomic commit and performance 
reasons, so no special hack was required.

Most of the original design survived intact, even in detail.  The 
variable inode attribute approach worked out well.  Inode attributes 
are serially encoded with a four bit tag, enough to cover all standard 
inode attributes and a few new ones.  This has yielded an exceptionally 
compact inode represention: currently 54 bytes, and further shrinkage 
is possible.  Variable length attributes are supported, which are 
currently used for extended attributes and later will be used to encode 
small files.  

Most of the structural complexity in Tux3 is located in the btree 
leaves, particularly file data btree leaves, our dleaf blocks.  These 
use a compact format that is easy to read but tricky to edit, and 
became more tricky when we added extents.  Adding versions to the 
extents will make that code trickier yet... a lot more tricky.  In 
classic Unix style, we fought this complexity by introducing a stream 
abstraction: when IO gets out of control, turn it into a stream.  Now 
the high level code is easy to work with and still pretty close to the 
metal.

So what happened to the volume table?  I initially thought that multiple 
subvolumes per physical volume was a great idea, as it would require 
little more effort than adding a table of tree roots sharing a single 
allocation map.  The hidden cost is sync: suppose you have one big, 
busy volume, and one small, lightly used volume, and you sync the small 
one.  You don't expect to wait while the big volume syncs as well, do 
you?  But that is exactly what will happen if they share the same 
allocation map, which has to be synced to disk, and because it must 
represent a consistent state for all subvolumes, all subvolumes have to 
be synced too.

There are various ways to fix this.  For example, each subvolume could 
have its own allocation space, and for efficiency, allocate space on 
the volume in chunks.  Gee, that sounds like LVM, doesn't it?  In the 
end, I decided that subvolumes are nothing more than LVM volumes, and 
that is how they should be implemented.  If there are issues with LVM 
and LVM integration with filesystems, that's what we should be fixing, 
not trying to turn our filesystem into a volume manager.

More details here:

   http://kerneltrap.org/mailarchive/tux3/2008/8/30/3134124
   "Feature interaction between multiple volumes and atomic update"

Regards,

Daniel
