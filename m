Return-Path: <linux-kernel-owner+w=401wt.eu-S1752307AbXCOB5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbXCOB5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 21:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXCOB5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 21:57:40 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:41279 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbXCOB5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 21:57:37 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2007 21:57:37 EDT
From: Edward Shishkin <edward@namesys.com>
Organization: Namesys
To: Reiserfs list <reiserfs-list@namesys.com>
Subject: Reiser4: Transparent compression support. Further development and compatibility.
Date: Thu, 15 Mar 2007 03:57:24 +0300
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703150357.24405.edward@namesys.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux list <linux-kernel@vger.kernel.org>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


       Reiser4 file system: Transparent compression support.
              Further development and compatibility.


   A. Reiser4 cryptcompress file plugin(*) and its conversion(**)


This is the second file plugin that realizes regular files in reiser4.
Unlike previous one (unix-file plugin), cryptcompress plugin manages
files with encrypted and(or) compressed bodies packed to metadata
pages, so plain text is cached in data pages (pinned to inode's
mapping), which don't participate in IO: at background commit their
data get compressed with the following update of old compressed
bodies. This update is going in so-called "squalloc" phase of the
flush algorithm, so eventually everything will be tightly packed.
And yes, metadata pages are supposed to be writebacked. Roughly
speaking, cryptcompress file occupies more memory and smaller disk
space then ordinary file (managed by unix-file plugin). In contrast
with unix-file plugin, the smallest addressable unit is page cluster
(in memory) and item cluster (on disk). Also cryptcompress plugin
implements another, more economic approach in representing holes.
However it calls the same low-level (node, etc) plugins, so you can
have a "mixed" fileset on your reiser4 partition. See below about
backward compatibility.

To reduce cpu and memory usage when handling incompressible data one
should assign proper compression mode plugin. The default one
activates special hook in ->write() method of cryptcompress file
plugin (only once per file's life, when starting to write from special
offset in some iteration) which tries to estimate whether a file is
compressible by testing its first logical cluster (64K by default).
If evaluation result is negative, then fragments will be converted to
extents, and management will be passed to unix-file plugin. Back
conversion does not take place. If evaluation result is positive, then
file stays under cryptcompress plugin control, but compression will be
dynamically switched by flush manager in accordance with the policy
implemented by compression mode plugin. This heuristic looks mostly
like improvisation and might be improved via modifying the compression
mode plugin (***) (some statistical analysis is needed here to make
sure we don't worsen the situation).

So let's summarize what we have in the cases of not success in primary
evaluation performed by default mode:

1. file is incompressible, but its first logical cluster is
   compressible. In this case compression will be "turned off" in
   flush time, so we save only cpu, whereas memory consumption is
   wasteful, as file stays under cryptcomptress plugin control. Also
   deleting a huge file built of fragments is not the fastest
   operation.
2. file is compressible, but its first logical cluster is
   incompressible. In this case management will be passed to the
   unix-file plugin forever (not the worse situation).

---
(*) "plugins" means "internal reiser4 modules". Perhaps, "plugin" is a
bad name, but let us use it in the context of reiser4 (at least for
now). Each plugin is labeled by a unique pair (type, id), so plugin's
name is composed of id name (first) and type name. For example,
"extent item plugin" means plugin of item type that manages extent
pointers in reiser4. Plugins of file type are to service VFS
entrypoints.

(**) plugin conversion means passing management to another plugin of
the same plugin type: (type, id1) -> (type, id2) with the following
(or preceded) conversion of controlled objects (tail conversion is a
classic example of such operation).

(***) when modifying an existing plugin we should be careful (see
below about backward compatibility).


            B. Getting started with cryptcompress plugin


****************** Warning! Warning! Warning! ************************

This stuff is experimental.
Do not store important data in the files managed by cryptcompress
plugin. It can be lost with no chances to recover it back. Also
creating at least one such file on your product Reiser4 partition can
cause its unrecoverable crash. It is not a joke!

**********************************************************************

NOTE: We don't consider using pseudo interface (metas), as it is still
deprecated.

1. Build and boot the latest kernel of -mm series.
2. Build and install the latest version of reiser4progs(1.0.6 for now)
3. Have a free partition (not for product using).
4. Format it by mkfs.reiser4. Use the option -o to override "create"
   and maybe other related plugins that mkfs installs to root
   directory by default.
   List of default settings is available via option -p.
   List of all possible settings is available via option -l
   For example:

   "mkfs.reiser4 -o create=ccreg40 /dev/xxx"
   specifies cryptcompress file plugin with (default) lzo1 compression
   "mkfs.reiser4 -o create=ccreg40,compress=gzip1 /dev/xxx"
   specifies cryptcompress file plugin with gzip1 compression.

   Description of all cryptcompress-related settings can be found
   here: http://dev.namesys.com/CryptcompressSettings

5. Mount the reiser4 file system (better with noatime option).
6. Have a fun.

NOTE: If you use cryptcompress plugin, then the only way to monitor
real disk space usage is looking at a counter of free blocks in
superblock (for example, df (1)), but first of all make sure (for
example, by sync (1)), that there is no dirty pages in memory,
otherwise df will show incorrect information (will be fixed).

du (1) statistics does not reflect (online) real space usage, as
i_bytes and i_blocks are unsupported by cryptcompress plugin
(supporting those fields "on-line" leads to performance drop).
However, their proper values can be set "offline" by reiser4.fsck.

NOTE:
1. Currently ciphering is unsupported (for this to work, some human
   key manager is needed).
2. Don't create loopback devices over files managed by cryptcompress
   plugin, as it doesn't work properly for now.
3. Make sure your boot partition does not contain files managed by
   cryptcompress plugin, as grub does not support this.	


                     C. Compatibility


WARNING: Don't try to check/repair your partition that contains
cryptcompress files with reiser4progs of version less then 1.0.6. Also
don't try to mount such partition in old kernels < 2.6.18-mm3.

We hope to completely avoid such compatibility problems (and therefore
to get rid of "don't mount to kernelXXX" and "don't check by
reiser4progsYYY" stuff) in future via using a simple technique based
on plugin architecture as it is described in the document appended
below. All comments, suggestions and, of course, bugreports are
welcome:
<reiserfs-dev at namesys dot com>,
<reiserfs-list at namesys dot com>.

Hope, you'll find this stuff useful.
Reiserfs team.


Appendix D.
Devoted to resolving backward compatibility problems in Reiser4.
Directed to file system developers and anyone with an interest in
Reiser4 and plugin architecture.


  Reiser4 file system: development, versions and compatibility.

                      Edward Shishkin


             1. Backward compatibility problems


Such problems arise when user downgrades kernel or fsprogs package:
old ones can be not aware of new objects on his partition. We have
tried to resolve backward compatibility problems using plugin
architecture that reiser4 is based on. The main idea is very simple:
to reduce them to a problem of "unknown" plugins". However, this puts
some restrictions to the development model. Such approach (introduced
in 2.6.18-mm3 and reiser4progs-1.0.6) is considered below in details.
On one's way we try to clarify reiser4 possibilities in the
development aspect.


                2. Core and plugins. SPL and FPL


Reiser4 kernel module consists of core code and plugins. Core includes
balancing, transaction manager, flush manager, etc. code manipulates
with virtual objects like formatted nodes, items, etc. Such
virtualization technology is not new and is used everywhere
(manipulations with VFS is a good example). Now it should be easy to
understand a concept of reiser4 plugin, the basic concept of reiser4
file system. Reiser4 plugin is a kernel data structure filled by
pointers to some functions (its "methods"). Each reiser4 plugin is
labeled by a unique pair (type, id), globally persistent plugin
identifier, so plugins with the same first components are of the same
type of data (struct typename_plugin). Plugin name is composed of id
name (first) and type name. For example: "extent item plugin" means
plugin of item type which manages extent pointers in reiser4. All
plugins of any type are initialized by the array typename_plugins.
Every reiser4 plugin has its counterpart in reiser4progs (1**).

Every reiser4 plugin belongs to one of the following two libraries
(the same for reiser4progs):

First library, SPL (per-Superblock Plugins Library), aggregates
plugins that work with low-level disk layouts (superblock, formatted
nodes, bitmap nodes, journal, etc). (Disk) format in reiser4 is a disk
format plugin (i.e plugin labeled by the pair (disk_format, id)). Disk
format are assigned per superblock. Disk format plugin installs node
plugin and some other SPL members to reiser4 superblock in mount time.
SPL has a version number defined as greatest supported disk format
plugin id.

Second library, FPL (per-File Plugins Library), aggregates so called
file managers which are to work with disk layouts (like item plugin),
represent some formatting policy (like formatting plugin), etc.
The "uppermost" plugins of file type are to service VFS entry points.
File managers are pointed by inode's plugin table (pset) described by
data structure plugin_set filled by pointers to plugins. Attributes
(type, id) of non-default file managers pointed in object's pset are
packed/extracted like other attributes to/from disk stat-data by
special stat-data item plugin. We associate FPL with a set of pairs
{(type, id) | type = file, directory, item, hash, ...}. FPL version
number is defined by another, more economic way (2**).

Every plugin has a version number defined as minimal version of
library which contains that plugin.

General version of reiser4 kernel module is defined as 4.X.Y, so that
X is version of SPL, and Y is version of FPL. We will say that X is
SPL-subversion, and Y is FPL-subversion of reiser4 kernel module. The
same for reiser4progs.


                  3. General disk version


Every reiser4 partition has general disk version 4.X.Y. Number X is
assigned by mkfs as some disk format plugin id (format 4.X) supported
by reiser4progs package, and can not be changed in future.
Y is assigned as FPL version of mkfs with the following upgrade at
mount time in accordance with kernel FPL version: if user mounts 4.A.B
to kernel with reiser4 module of general version 4.C.D, so that B < D,
and mount is okay, then general disk version will be updated to 4.A.D.
We will say that X is format subversion, and Y is FPL-subversion of
reiser4 partition.


             4. Definition of development model


Here goes a set of rules which are not to be encoded. But first some
helper definitions.

Upgrading SPL means contributing a set of new SPL members, which
must include new disk format plugin.
Upgrading FPL means contributing a set of new FPL members and
incrementing FPL version number.

Upgrading reiser4 kernel module (reiser4progs) means upgrading SPL
and(or) upgrading FPL.

. Developer is allowed to upgrade reiser4 kernel module and
  reiser4progs (3**).
. Kernel and reiser4progs should be upgraded simultaneously.
. Every such upgrade should be performed via applying a single
  incremental patch.
. No "development branches", i.e. don't modify existing plugins (4**).
  Issue only proved incremental patches.

As we will see below, such restrictions will help to provide
compatibility.


                 5. Supporting disk versions


Here we describe encoded support of the development model above. This
is what we aimed to minimize.

Suppose we want to mount a filesystem of version 4.A.B to kernel with
reiser4 module of version 4.C.D (or want to check it by reiser4progs
of such version). At first, kernel/reiser4progs will check format
subversion A. If A > C, then, obviously, format id A is unsupported by
kernel/reiser4progs, and mount/check will be refused. Suppose, format
subversion A is ok(supported). If B <= D, then in accordance with (4)
pset members packed in disk stat-data of every object are supported by
kernel/reiser4progs and there is no problems. The most interesting
case is when B > D. It means that disk can contain plugins that
kernel/reiser4progs is not aware of. Kernel and reiser4progs will
support such file system by different ways.


5.1. Kernel: fine-grained access to disk objects


First, some definitions.

If some plugin (file manager) is not listed by FPL of some kernel,
then we say that this plugin is unknown for this kernel, and file
managed by this plugin is not available in this kernel.

As it was mentioned above, all file managers are pointed by inode's
pset which is extracted from disk stat-data at ->lookup() time, and in
our approach this is the time when kernel recognizes unavailable
objects: if plugin stat-data extension contains unknown plugin type or
id, then read_inode() will return -EINVAL (or another value to
indicate that object is not available) and bad inode will be created.
Plugins missed in stat-data extension are assigned by kernel from file
system defaults, and, hence, are "known".

5.2. Reiser4progs: access "all or nothing"

Reiser4progs should be more suspicious about "unknown" plugins, as it
can be a result of metadata corruption. So if B > D, then reiser4progs
will refuse to work with such file system and user will be suggested
to upgrade reiser4progs. If reiser4progs package is uptodate (B <= D),
then unknown plugin type or id means metadata corruption that will be
handled by proper way.


                6. Definition of compatibility


So, if B > D, then in spite of successful mount, in accordance with
(5.1) some disk objects can be inaccessible, and an interesting
question arises here: "what objects must be accessible in the case of
such partial access?". To answer this, we need some definitions.

. If some object of a semantic tree was created by kernel/reiser4progs
  with FPL of version V, then we say that this object has version V.

Let's consider for every object Z of the semantic tree its version v(Z).

. If every object Z of the semantic tree is available in every kernel
  with FPL of version >= v(Z), then we say, that the development model
  is (weakly) compatible.

In contrast with (weak) compatibility, strong compatibility requires
each object to be accessible regardless of downgrade deepness. However
such concept does not have practical interest, and we won't consider
it. So we have a short answer on the question above: "development
model must be (weakly) compatible".

Note, that we define v(Z) to not depend on SPL version.


                     7. Plugin conversion


Plugins are allowed to modify object's plugin table (pset). This is a
case of so called plugin conversion, when management is passed to
another plugin of the same type: (type, id1) -> (type, id2). So,
plugin conversion is a type safe operation. Such dynamic (on-the fly)
conversion can be useful (5**). Examples:

. tail conversion (passing management from tail to extent item plugin
  and back) performed for files managed by unix-file plugin. Came from
  reiserfs (v3), although nobody suspected that this is a kind of such
  plugin operation;
. file conversion (passing management from cryptcompress to unix file
  plugin) performed for incompressible files.

Definition. If plugin conversion doesn't increase plugin version, then
we say it is squeezing.


                8. How to provide compatibility?


Now it should be obviously, how to provide it: just upgrade reiser4
kernel module and reiser4progs in accordance with the
instructions (4).

Statement. "2-dimentional" development model defined by instructions
(4) is (weakly) compatible.

Proof. In accordance with definition of compatibility, it is enough to
consider only upgrading FPL. In accordance with the instructions (4)
every implemented plugin conversion is squeezing. Let's consider a
root node R of the semantic tree, so R consists of root directory and
all its entries. Since version of plugins pointed by root pset can not
be increased (6**), we have that every object Z of R is available in
every kernel with FPL of version >= v(Z). Do the same for every node
of the semantic tree in descending order.


 9. On-disk evolution of format 4.X in compatible development model


How this theory looks in real life.

Suppose user has created (by mkfs) a file system of version 4.X.i, and
want to mount empty file system to kernel with version 4.Y.j (Y >= X).
If i < j, then kernel will upgrade disk version to 4.X.j and user will
be suggested to run fsck to update also backup blocks (7**). If i > j,
then kernel will complain that its FPL-subversion is too small, so
some files can be inaccessible. Actually even empty root directory can
be inaccessible in ancient kernels (if so, then mount will be
refused).
Suppose, mount was okay, and user was working for a long time with
this partition upgrading kernel from time to time, so FPL-subversion
numbers got upgraded to j_1, j_2, ...j_k (j < j_1 < ... < j_k). This
scenario defines on the latest FPL = FPL(j_k) a structure of nested
subsets (filtration):

FPL(j) < FPL(j_1) < FPL(j_2) < ... < FPL(j_k),

which induces filtration on the latest snapshot of user's semantic
tree:

T(j) <= T(j_1) <= T(j_2) <= ... <= T(j_k).

Here "<=" means "subtree" (i.e. T(j_1) is a subset of T(j_2), moreover
T(j_1) is a tree with the same root). T(j_s) is a snapshot of the
semantic tree that was upgraded to j_(s+1), or a part of this snapshot
(if something was removed after later upgrades). T(j_s)\T(j_(s-1))
("\" is "without") contains objects of version j_s.

In accordance with the development model above all elements of T(j_s)
are managed by plugins of versions <= j_s, and, hence, all of them
will be accessible in kernels with FPL version >= j_s.


          10. Subversion numbers: why do we need this?


One can ask: "Why do we need to keep/manage FPL-subversion numbers?
Just add new per-file plugins properly, and everything will be
recognized/handled automatically". For sure, indeed. However, keeping
track of them is useful for some reasons:

. For fsck to catch metadata corruption as it was described in (5.2).
. For various accessibility issues. For example, you have offline
reiser4 partition and want to know what kernel will provide full
access (not restricted) to all objects (solution: run debugfs.reiser4,
look at disk subversion number, then have a kernel with appropriate
FPL version). 


                         11. Examples


11.1. Transparent compression support

The following is a list of FPL members that have been added for such
support:

. cryptcompress file plugin
. ctail item plugin
. compression transform plugins (new type)
. compression mode plugins (new type)

11.2. Transparent encryption support

Not yet implemented. It is supposed to be implemented for existing
cryptcompress file plugin: one just need to add cipher transform
plugins (it should be wrappers for linux crypto-api) and provide human
key manager.

11.3. Supporting ECC-signatures for metadata protection

Not yet implemented. In order to support such signatures we need new
node format and, hence, new disk format plugin id. ECC signature
should be checked by zload() for data integrity and possible error
correction, and updated in commit time right before writing to disk.

11.4. Supporting xattrs

Not yet implemented. Here we need new stat-data extension plugin (for
packing/extracting namespaces, etc.) and a new file plugin as the most
graceful way to not allow old objects acquire new stat-data extension
(i.e. to not break compatibility).

------
(1**) Counterpart with the same (type, id) in reiser4progs can do
different work. For example, fsck doesn't perform data decompression,
but uses compression plugin (namely, its ->checksum() method) to check
data integrity.

(2**) Currently it is hardcoded, see definition of
PLUGIN_LIBRARY_VERSION in kernel (reiser4/plugin/plugin.h) and
reiser4progs (include/reiser4/plugin.h).

(3**) We don't consider modifications of core code, as it doesn't
break compatibility, at least we put efforts for this.

(4**) However, anyway, it is impossible to avoid various bugfixes and
micro-optimizations. Instructions about modifications of existing
plugins is out of this paper. For now just make sure, that they don't
break compatibility. Changing disk layouts and using non-squeezing
plugin conversion is unacceptable.

(5**) Actually, it is not easy to implement plugin conversion: most
likely that it won't be a simple update of file's plugin table (pset),
but will also require conversion of controlled objects and
serialization of critical code sections that work with shared pset.

(6**) Actually, plugin set of root directory can not be changed at
all, as it defines "default settings" for the partition.

(7**) Backup blocks are copies of main superblock spread through the
whole partition. Before updating backup blocks, fsck will check the
whole partition for consistency. It shouldn't cause discomfort, as
upgrading reiser4 is not a frequent event. Anyway, specification of
backup blocks is quite complex and it is better for kernel to not be
aware about them (they just look as busy blocks for kernel). Updating
status of backup blocks is reflected by special flag in superblock.
Mounting with not updated backup blocks is possible without any
additional options: kernel will warn for every such mount. When
rebuilding crashed filesystem with not updated backup blocks, user
will be suggested to confirm that new disk version in main superblock
is correct (not a result of metadata corruption).
