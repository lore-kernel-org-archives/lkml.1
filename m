Return-Path: <linux-kernel-owner+w=401wt.eu-S965304AbXBLSzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965304AbXBLSzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965302AbXBLSzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:55:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965305AbXBLSzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:55:14 -0500
Message-ID: <45D0B78F.4030309@redhat.com>
Date: Mon, 12 Feb 2007 13:53:03 -0500
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Looking at space used by objects in slab allocator
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After last week's experiment reducing size of task_struct on I was
curious to see what things are using up memory on the system and which
structs have the largest impact on the space used. /proc/slabinfo
provides information about the number objects allocated and their
sizes. With one line script the amount of space allocated for various
objects can be ranked in the output form object, count, and
accumulated total :

cat /proc/slabinfo | awk '{ print $1 " " $2 " " $4 " " $2*$4}' |sort -nrk 4


Running this script on an x86_64 Fedora Core Rawhide machine with 1GB
of DRAM building a kernel yielded the top ten slab object allocations as
(<name> <number> <active_obj> <space>):

ext3_inode_cache 18824 1400 26353600
buffer_head 163640 128 20945920
radix_tree_node 12744 576 7340544
dentry_cache 19543 272 5315696
selinux_inode_security 20829 192 3999168
avtab_node 80319 48 3855312
size-32 49882 56 2793392
inode_cache 1404 1032 1448928
size-64 11808 88 1039104
size-2048 360 2072 745920


The running kernel is using a bit more space (3 words (24 bytes) per
allocation) because the following slab allocation debugging is turned
on:

CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y

The following script lists the total slab allocation and amount used
due to 3 words per allocation (on 32-bit machine the 24 below should be
changed to 12):


cat /proc/slabinfo | \
awk 'BEGIN {doverhead=0; rsum = 0 } \
  { rsum += $2*$4; doverhead += $2*24;} END \
  { print "space:   ", rsum; \
   print "overhead:", doverhead; \
   print "percent: ", (doverhead*100)/rsum }'

Looks like the slab debugging adds about 12% to the memory used on the
64-bit machine, but this will vary depending on the objects.

space:    79562544
overhead: 9627048
percent:  12.1


One of the things that would be desirable is to minimize the amount of
wasted space on the slabs. The following script lists out the wasted space
on each kind of slab. The last field is the space wasted for each slab

cat /proc/slabinfo | sed '1,2 d' |\
  awk '{ emptyslab=(4096*$6-$4*$5); \
         slabs=$3/$5; \
      print $1 " " $4 " " $5 " " $5*$4 " " emptyslab  " " slabs*emptyslab}' | \
sort -nrk 6|more

Below is exerpt of the data when building a kernel showing things
wasting more that 50KBytes

<name> <size> <obj/slab> <used_space/slab> <empty_space/slab> <total_waste>
ext3_inode_cache 1400 2 2800 1296 6457968
inode_cache 1032 3 3096 1000 736000
dentry_cache 272 14 3808 288 673632
buffer_head 128 30 3840 256 512000
avtab_node 48 77 3696 400 417600
size-32 56 67 3752 344 257656
size-2048 2072 3 6216 1976 245024
selinux_inode_security 192 20 3840 256 168448
proc_inode_cache 1064 3 3192 904 122944
radix_tree_node 576 7 4032 64 121472
sighand_cache 2128 3 6384 1808 56048
task_struct 3776 1 3776 320 50240

The is a signficant amount of space wasted for ext3_inode_cache. If
the struct used for ext3_inode_cache struct could be made smaller,
three objects rather than two could fit in a slab. Fitting 3 objects
to a page would decrease the space required for ext3_inod_cache from
20.4MB to 13.6MB in this example.

-Will
