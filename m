Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbYIYCWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbYIYCWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbYIYCWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:22:41 -0400
Received: from phunq.net ([64.81.85.152]:55374 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752202AbYIYCWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:22:40 -0400
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: Tux3 gets a high speed atom smasher
Date: Wed, 24 Sep 2008 19:22:31 -0700
User-Agent: KMail/1.9.5
Cc: linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809241922.32517.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi filesystem aficionados,

The Large Hadron Collider no longer has a monopoly on smashing atoms, 
now that Tux3 has weighed in with a bit of its own atom smashing.  
Probably the coolest idea that has seen the light of day so far in Tux3 
is the concept of xattr atoms: numeric tokens that stand for xattr 
names.  In contrast to pretty much every other filesystem out there, 
Tux3 looks up an xattr in two stages:

  1) Look up the attribute name in the atom table
  2) Search for the atom in the inode's xattr cache

The sticky issue here is that there is no limit on the number of 
different xattr names that are possible, which means that there is no 
limit on the size of the atom table.  The fact that the number of 
distinct names used in practice tends to be very small is, 
unfortunately, insufficient justification to ignore the fact that 
nothing prevents the atom table from growing without bound.  Unless 
preventative measures are taken, any unprivileged user could carry out 
a denial of service attack simply by creating and deleting random 
xattrs on a file until the entire disk volume is filled with unused 
xattr names.

Addressing this problem required a lot of soul searching and wild design 
banter.  Finally we convinced ourselves that the only way to avoid the 
alligators in that marsh would be to implement full blown persistent 
reference counting for xattr names.  A reverse mapping table would also 
be necessary in order to be able to implement listxattr efficiently.  
Though these things sound scary and complex, it ended up being 
implemented in a really small amount of nicely efficient code.

Here is the main design thread:

   http://kerneltrap.org/mailarchive/tux3/2008/9/12/3274834/thread
   "More xattr design details"

and here we obsess over the tradeoffs at a level of detail I will spare 
you from here:

   http://tux3.org/pipermail/tux3/2008-September/000143.html
   "The long and short of extended attributes"

What is missing from those threads is the end result, alluded to here:

   http://tux3.org/pipermail/tux3/2008-September/000186.html
   "Atom refcounting redux"

And which I can state more succinctly now that the job is done: the 
entire extended attribute support for Tux3 is coded in less than 500 
lines, except for two pieces that will land later:

  * A hashed cache of xattr names sitting in front of the atom
    table.

  * Transaction support for atom table, reverse map and refcount
    updates.

These two pieces should be about 300 lines at most, or 800 lines total 
for xattr support, of which maybe 40% is devoted to resolving and 
refcounting xattr names.  The effect of the the hash table will be to 
tractor beam the xattr lookup performance up from dirop speed 
(microseconds) to memhash speed (nanoseconds).  Transaction support 
will make all the updates including refcounting and reverse mapping 
atomic.  With the help of Tux3's forward logging accelerator, the 
overhead for updating refcounts should be masked nicely by the 
unavoidable cost of getting the xattr data on to disk.  In the rosiest 
scenario, we end up winning by transferring less xattr data to/from 
disk due to atoms being much smaller than typical xattr names.

There is also one really esoteric hack going on to reduce the overhead 
of logging refcounts: each 32 bit count is divided into two 16 bit 
halves, with all the low halves stored on one set of map pages, and the 
high halves stored on a different set.  Thus, when many xattrs are 
being updated at once there will be few carries into the high order 
pages and disk bandwidth required to update batches of refcounts will 
be reduced by about half.  On top of that, we do not update the 
refcounts directly, but rather log refcount deltas logically and roll 
them up into the disk tables at relatively long intervals.  Such log 
entries are tucked into a portion of the transaction commit block in 
such a way that we get the extra logging more or less for free, by 
using otherwise idle commit block space.

I strongly suspect that Tux3 extended attributes will benchmark as well 
as existing implementations that just store xattr names directly and 
repetitively while requiring significantly less space to do it.  If 
this proves out in practice (the test is not all that far in the 
future) then we are going to be happy about it, and most probably 
extend the ideas further.  Tux3 atom support is not just about 
deduplicating xattr names: it is about deduplication in general.  If it 
works for xattr names then it will work for bodies as well, and most 
likely file data too.

If the implementation of this xattr atom idea had turned out to be a big 
rambling mess then I would most likely have just sighed, flushed it, 
and gone back to tried and true methods.  But it did not turn out to be 
a big mess, quite the contrary.  This was accomplished by reusing an 
existing component: Tux3 atoms are resolved via standard directory 
lookup (ext2_find_entry) which serves as a placeholder in Tux3 for a 
proper directory index that will arrive later.  Instead of storing an 
inode number in the directory, we store an atom number.

Another complexity-reduction measure involved mapping three atom-related 
tables into the same file:

  1) Atom lookup table (Ext2 directory)
  2) Atom refcount table
  3) Atom reverse map table (for listxattr)

The latter two tables are mapped at block 2^28 in the atom directory 
file, which has no particular adverse impact on a btree but may stress 
the kernel's page cache radix tree somewhat, which consequently is 
forced to be five levels deep as opposed to one or two for ordinary, 
non-sparse directory files.  I doubt this will show up as a performance 
artifact, but if it does there are several ways to fix it, for example:

  * Fiddle the page cache radix tree to have a single level of btree
    index at the top level for sparse files.

  * Keep an array of direct pointers to the atom table when it is
    small, which it nearly always will be.

  * Store the three tables in three separate inodes, big deal.

Coincidentally, I learned from plumbing the Btrfs repo that Josef Bacik 
similarly repurposed a directory mechanism in the direction of xattr 
support, but in a distinctly different way: Josef stores xattr bodies 
in a variant of the Btrfs directory (if I read it correctly) indexed by 
xattr name and inode.  On the other hand, Tux3's approach just puts 
atom numbers in a single, global directory.  Atom numbers happen to 
resemble inode numbers so strongly that ext2_find_entry just worked for 
this without alteration.  We might even use the Ext2 "type" byte field, 
intended as an ls accelerate, for some purpose or other.  Or maybe not!  
After all, the Ext2 directory scheme is just a placeholder in Tux3, 
until PHTree lands as described in the original design note:

  http://tux3.org/design.html
  "PHTree"

It turns out that classic HTree is better for indexing atoms than the 
cute new PHTree design because there is no directory traversal and thus 
no physical stability requirement.  Also there is no requirement for 
backward compatibility with Ext2 leaf format, so naturally we will use 
a more efficient format with a mini-btree mapped into the leaf block 
for that little extra performance edge and, we hope, nearly the same 
data density.

Of course, the best thing about the Tux3 atom smashing is that we do not 
require low-temperature superconductors, so it should be considerably 
more reliable.

Regards,

Daniel
