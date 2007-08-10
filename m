Return-Path: <linux-kernel-owner+w=401wt.eu-S940590AbXHJQSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940590AbXHJQSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940649AbXHJQI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:08:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940475AbXHJQIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:08:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/16] CacheFiles: A cache that backs onto a mounted
	filesystem [try #3]
To: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov
Date: Fri, 10 Aug 2007 17:06:03 +0100
Message-ID: <20070810160603.24698.49932.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070810160455.24698.30983.stgit@warthog.cambridge.redhat.com>
References: <20070810160455.24698.30983.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add an FS-Cache cache-backend that permits a mounted filesystem to be used as a
backing store for the cache.


CacheFiles uses a userspace daemon to do some of the cache management - such as
reaping stale nodes and culling.  This is called cachefilesd and lives in
/sbin.  The source for the daemon can be downloaded from:

	http://people.redhat.com/~dhowells/cachefs/cachefilesd.c

And an example configuration from:

	http://people.redhat.com/~dhowells/cachefs/cachefilesd.conf

The filesystem and data integrity of the cache are only as good as those of the
filesystem providing the backing services.  Note that CacheFiles does not
attempt to journal anything since the journalling interfaces of the various
filesystems are very specific in nature.

CacheFiles creates a proc-file - "/proc/fs/cachefiles" - that is used for
communication with the daemon.  Only one thing may have this open at once, and
whilst it is open, a cache is at least partially in existence.  The daemon
opens this and sends commands down it to control the cache.

CacheFiles is currently limited to a single cache.

CacheFiles attempts to maintain at least a certain percentage of free space on
the filesystem, shrinking the cache by culling the objects it contains to make
space if necessary - see the "Cache Culling" section.  This means it can be
placed on the same medium as a live set of data, and will expand to make use of
spare space and automatically contract when the set of data requires more
space.


============
REQUIREMENTS
============

The use of CacheFiles and its daemon requires the following features to be
available in the system and in the cache filesystem:

	- dnotify.

	- extended attributes (xattrs).

	- openat() and friends.

	- bmap() support on files in the filesystem (FIBMAP ioctl).

	- The use of bmap() to detect a partial page at the end of the file.

It is strongly recommended that the "dir_index" option is enabled on Ext3
filesystems being used as a cache.


=============
CONFIGURATION
=============

The cache is configured by a script in /etc/cachefilesd.conf.  These commands
set up cache ready for use.  The following script commands are available:

 (*) brun <N>%
 (*) bcull <N>%
 (*) bstop <N>%

	Configure the culling limits.  Optional.  See the section on culling
	The defaults are 7%, 5% and 1% respectively.

 (*) dir <path>

	Specify the directory containing the root of the cache.  Mandatory.

 (*) tag <name>

	Specify a tag to FS-Cache to use in distinguishing multiple caches.
	Optional.  The default is "CacheFiles".

 (*) debug <mask>

	Specify a numeric bitmask to control debugging in the kernel module.
	Optional.  The default is zero (all off).


==================
STARTING THE CACHE
==================

The cache is started by running the daemon.  The daemon opens the cache proc
file, configures the cache and tells it to begin caching.  At that point the
cache binds to fscache and the cache becomes live.

The daemon is run as follows:

	/sbin/cachefilesd [-d]* [-s] [-n] [-f <configfile>]

The flags are:

 (*) -d

	Increase the debugging level.  This can be specified multiple times and
	is cumulative with itself.

 (*) -s

	Send messages to stderr instead of syslog.

 (*) -n

	Don't daemonise and go into background.

 (*) -f <configfile>

	Use an alternative configuration file rather than the default one.


===============
THINGS TO AVOID
===============

Do not mount other things within the cache as this will cause problems.  The
kernel module contains its own very cut-down path walking facility that ignores
mountpoints, but the daemon can't avoid them.

Do not create, rename or unlink files and directories in the cache whilst the
cache is active, as this may cause the state to become uncertain.

Renaming files in the cache might make objects appear to be other objects (the
filename is part of the lookup key).

Do not change or remove the extended attributes attached to cache files by the
cache as this will cause the cache state management to get confused.

Do not create files or directories in the cache, lest the cache get confused or
serve incorrect data.

Do not chmod files in the cache.  The module creates things with minimal
permissions to prevent random users being able to access them directly.


=============
CACHE CULLING
=============

The cache may need culling occasionally to make space.  This involves
discarding objects from the cache that have been used less recently than
anything else.  Culling is based on the access time of data objects.  Empty
directories are culled if not in use.

Cache culling is done on the basis of the percentage of blocks available in the
underlying filesystem.  There are three "limits":

 (*) brun

     If the amount of available space in the cache rises above this limit, then
     culling is turned off.

 (*) bcull

     If the amount of available space in the cache falls below this limit, then
     culling is started.

 (*) bstop

     If the amount of available space in the cache falls below this limit, then
     no further allocation of disk space is permitted until culling has raised
     the amount above this limit again.

These must be configured thusly:

	0 <= bstop < bcull < brun < 100

Note that these are percentages of available space, and do _not_ appear as 100
minus the percentage displayed by the "df" program.

The userspace daemon scans the cache to build up a table of cullable objects.
These are then culled in least recently used order.  A new scan of the cache is
started as soon as space is made in the table.  Objects will be skipped if
their atimes have changed or if the kernel module says it is still using them.


===============
CACHE STRUCTURE
===============

The CacheFiles module will create two directories in the directory it was
given:

 (*) cache/

 (*) graveyard/

The active cache objects all reside in the first directory.  The CacheFiles
kernel module moves any retired or culled objects that it can't simply unlink
to the graveyard from which the daemon will actually delete them.

The daemon uses dnotify to monitor the graveyard directory, and will delete
anything that appears therein.


The module represents index objects as directories with the filename "I..." or
"J...".  Note that the "cache/" directory is itself a special index.

Data objects are represented as files if they have no children, or directories
if they do.  Their filenames all begin "D..." or "E...".  If represented as a
directory, data objects will have a file in the directory called "data" that
actually holds the data.

Special objects are similar to data objects, except their filenames begin
"S..." or "T...".


If an object has children, then it will be represented as a directory.
Immediately in the representative directory are a collection of directories
named for hash values of the child object keys with an '@' prepended.  Into
this directory, if possible, will be placed the representations of the child
objects:

	INDEX     INDEX      INDEX                             DATA FILES
	========= ========== ================================= ================
	cache/@4a/I03nfs/@30/Ji000000000000000--fHg8hi8400
	cache/@4a/I03nfs/@30/Ji000000000000000--fHg8hi8400/@75/Es0g000w...DB1ry
	cache/@4a/I03nfs/@30/Ji000000000000000--fHg8hi8400/@75/Es0g000w...N22ry
	cache/@4a/I03nfs/@30/Ji000000000000000--fHg8hi8400/@75/Es0g000w...FP1ry


If the key is so long that it exceeds NAME_MAX with the decorations added on to
it, then it will be cut into pieces, the first few of which will be used to
make a nest of directories, and the last one of which will be the objects
inside the last directory.  The names of the intermediate directories will have
'+' prepended:

	J1223/@23/+xy...z/+kl...m/Epqr


Note that keys are raw data, and not only may they exceed NAME_MAX in size,
they may also contain things like '/' and NUL characters, and so they may not
be suitable for turning directly into a filename.

To handle this, CacheFiles will use a suitably printable filename directly and
"base-64" encode ones that aren't directly suitable.  The two versions of
object filenames indicate the encoding:

	OBJECT TYPE	PRINTABLE	ENCODED
	===============	===============	===============
	Index		"I..."		"J..."
	Data		"D..."		"E..."
	Special		"S..."		"T..."

Intermediate directories are always "@" or "+" as appropriate.


Each object in the cache has an extended attribute label that holds the object
type ID (required to distinguish special objects) and the auxiliary data from
the netfs.  The latter is used to detect stale objects in the cache and update
or retire them.


Note that CacheFiles will erase from the cache any file it doesn't recognise or
any file of an incorrect type (such as a FIFO file or a device file).


This documentation is added by the patch to:

	Documentation/filesystems/caching/cachefiles.txt

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/caching/cachefiles.txt |  395 ++++++++++
 fs/Kconfig                                       |    1 
 fs/Makefile                                      |    1 
 fs/cachefiles/Kconfig                            |   33 +
 fs/cachefiles/Makefile                           |   18 
 fs/cachefiles/cf-bind.c                          |  288 +++++++
 fs/cachefiles/cf-daemon.c                        |  720 +++++++++++++++++++
 fs/cachefiles/cf-interface.c                     |  442 +++++++++++
 fs/cachefiles/cf-internal.h                      |  420 +++++++++++
 fs/cachefiles/cf-key.c                           |  159 ++++
 fs/cachefiles/cf-main.c                          |  109 +++
 fs/cachefiles/cf-namei.c                         |  743 +++++++++++++++++++
 fs/cachefiles/cf-proc.c                          |  166 ++++
 fs/cachefiles/cf-rdwr.c                          |  849 ++++++++++++++++++++++
 fs/cachefiles/cf-security.c                      |  114 +++
 fs/cachefiles/cf-xattr.c                         |  292 ++++++++
 16 files changed, 4750 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/caching/cachefiles.txt b/Documentation/filesystems/caching/cachefiles.txt
new file mode 100644
index 0000000..b502cff
--- /dev/null
+++ b/Documentation/filesystems/caching/cachefiles.txt
@@ -0,0 +1,395 @@
+	       ===============================================
+	       CacheFiles: CACHE ON ALREADY MOUNTED FILESYSTEM
+	       ===============================================
+
+Contents:
+
+ (*) Overview.
+
+ (*) Requirements.
+
+ (*) Configuration.
+
+ (*) Starting the cache.
+
+ (*) Things to avoid.
+
+ (*) Cache culling.
+
+ (*) Cache structure.
+
+ (*) Security model and SELinux.
+
+========
+OVERVIEW
+========
+
+CacheFiles is a caching backend that's meant to use as a cache a directory on
+an already mounted filesystem of a local type (such as Ext3).
+
+CacheFiles uses a userspace daemon to do some of the cache management - such as
+reaping stale nodes and culling.  This is called cachefilesd and lives in
+/sbin.
+
+The filesystem and data integrity of the cache are only as good as those of the
+filesystem providing the backing services.  Note that CacheFiles does not
+attempt to journal anything since the journalling interfaces of the various
+filesystems are very specific in nature.
+
+CacheFiles creates a misc character device - "/dev/cachefiles" - that is used
+to communication with the daemon.  Only one thing may have this open at once,
+and whilst it is open, a cache is at least partially in existence.  The daemon
+opens this and sends commands down it to control the cache.
+
+CacheFiles is currently limited to a single cache.
+
+CacheFiles attempts to maintain at least a certain percentage of free space on
+the filesystem, shrinking the cache by culling the objects it contains to make
+space if necessary - see the "Cache Culling" section.  This means it can be
+placed on the same medium as a live set of data, and will expand to make use of
+spare space and automatically contract when the set of data requires more
+space.
+
+
+============
+REQUIREMENTS
+============
+
+The use of CacheFiles and its daemon requires the following features to be
+available in the system and in the cache filesystem:
+
+	- dnotify.
+
+	- extended attributes (xattrs).
+
+	- openat() and friends.
+
+	- bmap() support on files in the filesystem (FIBMAP ioctl).
+
+	- The use of bmap() to detect a partial page at the end of the file.
+
+It is strongly recommended that the "dir_index" option is enabled on Ext3
+filesystems being used as a cache.
+
+
+=============
+CONFIGURATION
+=============
+
+The cache is configured by a script in /etc/cachefilesd.conf.  These commands
+set up cache ready for use.  The following script commands are available:
+
+ (*) brun <N>%
+ (*) bcull <N>%
+ (*) bstop <N>%
+ (*) frun <N>%
+ (*) fcull <N>%
+ (*) fstop <N>%
+
+	Configure the culling limits.  Optional.  See the section on culling
+	The defaults are 7% (run), 5% (cull) and 1% (stop) respectively.
+
+	The commands beginning with a 'b' are file space (block) limits, those
+	beginning with an 'f' are file count limits.
+
+ (*) dir <path>
+
+	Specify the directory containing the root of the cache.  Mandatory.
+
+ (*) tag <name>
+
+	Specify a tag to FS-Cache to use in distinguishing multiple caches.
+	Optional.  The default is "CacheFiles".
+
+ (*) debug <mask>
+
+	Specify a numeric bitmask to control debugging in the kernel module.
+	Optional.  The default is zero (all off).  The following values can be
+	OR'd into the mask to collect various information:
+
+		1	Turn on trace of function entry (_enter() macros)
+		2	Turn on trace of function exit (_leave() macros)
+		4	Turn on trace of internal debug points (_debug())
+
+	This mask can also be set through sysfs, eg:
+
+		echo 5 >/sys/modules/cachefiles/parameters/debug
+
+
+==================
+STARTING THE CACHE
+==================
+
+The cache is started by running the daemon.  The daemon opens the cache device,
+configures the cache and tells it to begin caching.  At that point the cache
+binds to fscache and the cache becomes live.
+
+The daemon is run as follows:
+
+	/sbin/cachefilesd [-d]* [-s] [-n] [-f <configfile>]
+
+The flags are:
+
+ (*) -d
+
+	Increase the debugging level.  This can be specified multiple times and
+	is cumulative with itself.
+
+ (*) -s
+
+	Send messages to stderr instead of syslog.
+
+ (*) -n
+
+	Don't daemonise and go into background.
+
+ (*) -f <configfile>
+
+	Use an alternative configuration file rather than the default one.
+
+
+===============
+THINGS TO AVOID
+===============
+
+Do not mount other things within the cache as this will cause problems.  The
+kernel module contains its own very cut-down path walking facility that ignores
+mountpoints, but the daemon can't avoid them.
+
+Do not create, rename or unlink files and directories in the cache whilst the
+cache is active, as this may cause the state to become uncertain.
+
+Renaming files in the cache might make objects appear to be other objects (the
+filename is part of the lookup key).
+
+Do not change or remove the extended attributes attached to cache files by the
+cache as this will cause the cache state management to get confused.
+
+Do not create files or directories in the cache, lest the cache get confused or
+serve incorrect data.
+
+Do not chmod files in the cache.  The module creates things with minimal
+permissions to prevent random users being able to access them directly.
+
+
+=============
+CACHE CULLING
+=============
+
+The cache may need culling occasionally to make space.  This involves
+discarding objects from the cache that have been used less recently than
+anything else.  Culling is based on the access time of data objects.  Empty
+directories are culled if not in use.
+
+Cache culling is done on the basis of the percentage of blocks and the
+percentage of files available in the underlying filesystem.  There are six
+"limits":
+
+ (*) brun
+ (*) frun
+
+     If the amount of free space and the number of available files in the cache
+     rises above both these limits, then culling is turned off.
+
+ (*) bcull
+ (*) fcull
+
+     If the amount of available space or the number of available files in the
+     cache falls below either of these limits, then culling is started.
+
+ (*) bstop
+ (*) fstop
+
+     If the amount of available space or the number of available files in the
+     cache falls below either of these limits, then no further allocation of
+     disk space or files is permitted until culling has raised things above
+     these limits again.
+
+These must be configured thusly:
+
+	0 <= bstop < bcull < brun < 100
+	0 <= fstop < fcull < frun < 100
+
+Note that these are percentages of available space and available files, and do
+_not_ appear as 100 minus the percentage displayed by the "df" program.
+
+The userspace daemon scans the cache to build up a table of cullable objects.
+These are then culled in least recently used order.  A new scan of the cache is
+started as soon as space is made in the table.  Objects will be skipped if
+their atimes have changed or if the kernel module says it is still using them.
+
+
+===============
+CACHE STRUCTURE
+===============
+
+The CacheFiles module will create two directories in the directory it was
+given:
+
+ (*) cache/
+
+ (*) graveyard/
+
+The active cache objects all reside in the first directory.  The CacheFiles
+kernel module moves any retired or culled objects that it can't simply unlink
+to the graveyard from which the daemon will actually delete them.
+
+The daemon uses dnotify to monitor the graveyard directory, and will delete
+anything that appears therein.
+
+
+The module represents index objects as directories with the filename "I..." or
+"J...".  Note that the "cache/" directory is itself a special index.
+
+Data objects are represented as files if they have no children, or directories
+if they do.  Their filenames all begin "D..." or "E...".  If represented as a
+directory, data objects will have a file in the directory called "data" that
+actually holds the data.
+
+Special objects are similar to data objects, except their filenames begin
+"S..." or "T...".
+
+
+If an object has children, then it will be represented as a directory.
+Immediately in the representative directory are a collection of directories
+named for hash values of the child object keys with an '@' prepended.  Into
+this directory, if possible, will be placed the representations of the child
+objects:
+
+	INDEX     INDEX      INDEX                             DATA FILES
+	========= ========== ================================= ================
+	cache/@4a/I03nfs/@30/Ji000000000000000--fHg8hi8400
+	cache/@4a/I03nfs/@30/Ji000000000000000--fHg8hi8400/@75/Es0g000w...DB1ry
+	cache/@4a/I03nfs/@30/Ji000000000000000--fHg8hi8400/@75/Es0g000w...N22ry
+	cache/@4a/I03nfs/@30/Ji000000000000000--fHg8hi8400/@75/Es0g000w...FP1ry
+
+
+If the key is so long that it exceeds NAME_MAX with the decorations added on to
+it, then it will be cut into pieces, the first few of which will be used to
+make a nest of directories, and the last one of which will be the objects
+inside the last directory.  The names of the intermediate directories will have
+'+' prepended:
+
+	J1223/@23/+xy...z/+kl...m/Epqr
+
+
+Note that keys are raw data, and not only may they exceed NAME_MAX in size,
+they may also contain things like '/' and NUL characters, and so they may not
+be suitable for turning directly into a filename.
+
+To handle this, CacheFiles will use a suitably printable filename directly and
+"base-64" encode ones that aren't directly suitable.  The two versions of
+object filenames indicate the encoding:
+
+	OBJECT TYPE	PRINTABLE	ENCODED
+	===============	===============	===============
+	Index		"I..."		"J..."
+	Data		"D..."		"E..."
+	Special		"S..."		"T..."
+
+Intermediate directories are always "@" or "+" as appropriate.
+
+
+Each object in the cache has an extended attribute label that holds the object
+type ID (required to distinguish special objects) and the auxiliary data from
+the netfs.  The latter is used to detect stale objects in the cache and update
+or retire them.
+
+
+Note that CacheFiles will erase from the cache any file it doesn't recognise or
+any file of an incorrect type (such as a FIFO file or a device file).
+
+
+==========================
+SECURITY MODEL AND SELINUX
+==========================
+
+CacheFiles is implemented to deal properly with the LSM security features of
+the Linux kernel and the SELinux facility.
+
+One of the problems that CacheFiles faces is that it is generally acting on
+behalf of a process, and running in that process's context, and that includes a
+security context that is not appropriate for accessing the cache - either
+because the files in the cache are inaccessible to that process, or because if
+the process creates a file in the cache, that file may be inaccessible to other
+processes.
+
+The way CacheFiles works is to temporarily change the security context (fsuid,
+fsgid and actor security label) that the process acts as - without changing the
+security context of the process when it the target of an operation performed by
+some other process (so signalling and suchlike still work correctly).
+
+
+When the CacheFiles module is asked to bind to its cache, it:
+
+ (1) Finds the security label attached to the root cache directory and uses
+     that as the security label with which it will create files.  By default,
+     this is:
+
+	cachefiles_var_t
+
+ (2) Finds the security label of the process which issued the bind request
+     (presumed to be the cachefilesd daemon), which by default will be:
+
+	cachefilesd_t
+
+     and asks LSM to supply a security ID as which it should act given the
+     daemon's label.  By default, this will be:
+
+	cachefiles_kernel_t
+
+     SELinux transitions the daemon's security ID to the module's security ID
+     based on a rule of this form in the policy.
+
+	type_transition <daemon's-ID> kernel_t : process <module's-ID>;
+
+     For instance:
+
+	type_transition cachefilesd_t kernel_t : process cachefiles_kernel_t;
+
+
+The module's security ID gives it permission to create, move and remove files
+and directories in the cache, to find and access directories and files in the
+cache, to set and access extended attributes on cache objects, and to read and
+write files in the cache.
+
+The daemon's security ID gives it only a very restricted set of permissions: it
+may scan directories, stat files and erase files and directories.  It may
+not read or write files in the cache, and so it is precluded from accessing the
+data cached therein; nor is it permitted to create new files in the cache.
+
+
+There are policy source files available in:
+
+	http://people.redhat.com/~dhowells/fscache/cachefilesd-0.8.tar.bz2
+
+and later versions.  In that tarball, see the files:
+
+	cachefilesd.te
+	cachefilesd.fc
+	cachefilesd.if
+
+They are built and installed directly by the RPM.
+
+If a non-RPM based system is being used, then copy the above files to their own
+directory and run:
+
+	make -f /usr/share/selinux/devel/Makefile
+	semodule -i cachefilesd.pp
+
+You will need checkpolicy and selinux-policy-devel installed prior to the
+build.
+
+
+By default, the cache is located in /var/fscache, but if it is desirable that
+it should be elsewhere, than either the above policy files must be altered, or
+an auxiliary policy must be installed to label the alternate location of the
+cache.
+
+For instructions on how to add an auxiliary policy to enable the cache to be
+located elsewhere when SELinux is in enforcing mode, please see:
+
+	/usr/share/doc/cachefilesd-*/move-cache.txt
+
+When the cachefilesd rpm is installed; alternatively, the document can be found
+in the sources.
diff --git a/fs/Kconfig b/fs/Kconfig
index 3e1c276..7feb4cb 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -634,6 +634,7 @@ config GENERIC_ACL
 menu "Caches"
 
 source "fs/fscache/Kconfig"
+source "fs/cachefiles/Kconfig"
 
 endmenu
 
diff --git a/fs/Makefile b/fs/Makefile
index 4eecc9a..becdb4f 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -116,6 +116,7 @@ obj-$(CONFIG_AFS_FS)		+= afs/
 obj-$(CONFIG_BEFS_FS)		+= befs/
 obj-$(CONFIG_HOSTFS)		+= hostfs/
 obj-$(CONFIG_HPPFS)		+= hppfs/
+obj-$(CONFIG_CACHEFILES)	+= cachefiles/
 obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
diff --git a/fs/cachefiles/Kconfig b/fs/cachefiles/Kconfig
new file mode 100644
index 0000000..ddbdd85
--- /dev/null
+++ b/fs/cachefiles/Kconfig
@@ -0,0 +1,33 @@
+
+config CACHEFILES
+	tristate "Filesystem caching on files"
+	depends on FSCACHE
+	help
+	  This permits use of a mounted filesystem as a cache for other
+	  filesystems - primarily networking filesystems - thus allowing fast
+	  local disk to enhance the speed of slower devices.
+
+	  See Documentation/filesystems/caching/cachefiles.txt for more
+	  information.
+
+config CACHEFILES_DEBUG
+	bool "Debug CacheFiles"
+	depends on CACHEFILES
+	help
+	  This permits debugging to be dynamically enabled in the filesystem
+	  caching on files module.  If this is set, the debugging output may be
+	  enabled by setting bits in /sys/modules/cachefiles/parameter/debug or
+	  by including a debugging specifier in /etc/cachefilesd.conf.
+
+config CACHEFILES_HISTOGRAM
+	bool "Gather latency information on CacheFiles"
+	depends on CACHEFILES && FSCACHE_PROC
+	help
+
+	  This option causes latency information to be gathered on CacheFiles
+	  operation and exported through file:
+
+		/proc/fs/fscache/cachefiles/histogram
+
+	  See Documentation/filesystems/caching/cachefiles.txt for more
+	  information.
diff --git a/fs/cachefiles/Makefile b/fs/cachefiles/Makefile
new file mode 100644
index 0000000..31186a4
--- /dev/null
+++ b/fs/cachefiles/Makefile
@@ -0,0 +1,18 @@
+#
+# Makefile for caching in a mounted filesystem
+#
+
+cachefiles-y := \
+	cf-bind.o \
+	cf-daemon.o \
+	cf-interface.o \
+	cf-key.o \
+	cf-main.o \
+	cf-namei.o \
+	cf-rdwr.o \
+	cf-xattr.o
+
+cachefiles-$(CONFIG_SECURITY) += cf-security.o
+cachefiles-$(CONFIG_CACHEFILES_HISTOGRAM) += cf-proc.o
+
+obj-$(CONFIG_CACHEFILES) := cachefiles.o
diff --git a/fs/cachefiles/cf-bind.c b/fs/cachefiles/cf-bind.c
new file mode 100644
index 0000000..90904e6
--- /dev/null
+++ b/fs/cachefiles/cf-bind.c
@@ -0,0 +1,288 @@
+/* Bind and unbind a cache from the filesystem backing it
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/completion.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/namei.h>
+#include <linux/mount.h>
+#include <linux/statfs.h>
+#include <linux/ctype.h>
+#include "cf-internal.h"
+
+static int cachefiles_daemon_add_cache(struct cachefiles_cache *caches);
+
+/*
+ * bind a directory as a cache
+ */
+int cachefiles_daemon_bind(struct cachefiles_cache *cache, char *args)
+{
+	_enter("{%u,%u,%u,%u,%u,%u},%s",
+	       cache->frun_percent,
+	       cache->fcull_percent,
+	       cache->fstop_percent,
+	       cache->brun_percent,
+	       cache->bcull_percent,
+	       cache->bstop_percent,
+	       args);
+
+	/* start by checking things over */
+	ASSERT(cache->fstop_percent >= 0 &&
+	       cache->fstop_percent < cache->fcull_percent &&
+	       cache->fcull_percent < cache->frun_percent &&
+	       cache->frun_percent  < 100);
+
+	ASSERT(cache->bstop_percent >= 0 &&
+	       cache->bstop_percent < cache->bcull_percent &&
+	       cache->bcull_percent < cache->brun_percent &&
+	       cache->brun_percent  < 100);
+
+	if (*args) {
+		kerror("'bind' command doesn't take an argument");
+		return -EINVAL;
+	}
+
+	if (!cache->rootdirname) {
+		kerror("No cache directory specified");
+		return -EINVAL;
+	}
+
+	/* don't permit already bound caches to be re-bound */
+	if (test_bit(CACHEFILES_READY, &cache->flags)) {
+		kerror("Cache already bound");
+		return -EBUSY;
+	}
+
+	/* make sure we have copies of the tag and dirname strings */
+	if (!cache->tag) {
+		/* the tag string is released by the fops->release()
+		 * function, so we don't release it on error here */
+		cache->tag = kstrdup("CacheFiles", GFP_KERNEL);
+		if (!cache->tag)
+			return -ENOMEM;
+	}
+
+	/* add the cache */
+	return cachefiles_daemon_add_cache(cache);
+}
+
+/*
+ * add a cache
+ */
+static int cachefiles_daemon_add_cache(struct cachefiles_cache *cache)
+{
+	struct cachefiles_secctx secctx;
+	struct cachefiles_object *fsdef;
+	struct nameidata nd;
+	struct kstatfs stats;
+	struct dentry *graveyard, *cachedir, *root;
+	int ret;
+
+	_enter("");
+
+	/* we want to work under the module's security ID */
+	ret = cachefiles_get_security_ID(cache);
+	if (ret < 0)
+		return ret;
+
+	cachefiles_begin_secure_nofs(cache, &secctx);
+
+	/* allocate the root index object */
+	ret = -ENOMEM;
+
+	fsdef = kmem_cache_alloc(cachefiles_object_jar, GFP_KERNEL);
+	if (!fsdef)
+		goto error_root_object;
+
+	ASSERTCMP(fsdef->backer, ==, NULL);
+
+	atomic_set(&fsdef->usage, 1);
+	fsdef->type = FSCACHE_COOKIE_TYPE_INDEX;
+
+	_debug("- fsdef %p", fsdef);
+
+	/* look up the directory at the root of the cache */
+	memset(&nd, 0, sizeof(nd));
+
+	ret = path_lookup(cache->rootdirname, LOOKUP_DIRECTORY, &nd);
+	if (ret < 0)
+		goto error_open_root;
+
+	cache->mnt = mntget(nd.mnt);
+	root = dget(nd.dentry);
+	path_release(&nd);
+
+	/* check parameters */
+	ret = -EOPNOTSUPP;
+	if (!root->d_inode ||
+	    !root->d_inode->i_op ||
+	    !root->d_inode->i_op->lookup ||
+	    !root->d_inode->i_op->mkdir ||
+	    !root->d_inode->i_op->setxattr ||
+	    !root->d_inode->i_op->getxattr ||
+	    !root->d_sb ||
+	    !root->d_sb->s_op ||
+	    !root->d_sb->s_op->statfs ||
+	    !root->d_sb->s_op->sync_fs)
+		goto error_unsupported;
+
+	ret = -EROFS;
+	if (root->d_sb->s_flags & MS_RDONLY)
+		goto error_unsupported;
+
+	/* determine the security of the on-disk cache as this governs
+	 * security ID of files we create */
+	ret = cachefiles_determine_cache_secid(cache, root);
+	if (ret < 0)
+		goto error_unsupported;
+
+	cachefiles_set_fscreate_secid(cache);
+
+	/* get the cache size and blocksize */
+	ret = vfs_statfs(root, &stats);
+	if (ret < 0)
+		goto error_unsupported;
+
+	ret = -ERANGE;
+	if (stats.f_bsize <= 0)
+		goto error_unsupported;
+
+	ret = -EOPNOTSUPP;
+	if (stats.f_bsize > PAGE_SIZE)
+		goto error_unsupported;
+
+	cache->bsize = stats.f_bsize;
+	cache->bshift = 0;
+	if (stats.f_bsize < PAGE_SIZE)
+		cache->bshift = PAGE_SHIFT - ilog2(stats.f_bsize);
+
+	_debug("blksize %u (shift %u)",
+	       cache->bsize, cache->bshift);
+
+	_debug("size %llu, avail %llu",
+	       (unsigned long long) stats.f_blocks,
+	       (unsigned long long) stats.f_bavail);
+
+	/* set up caching limits */
+	do_div(stats.f_files, 100);
+	cache->fstop = stats.f_files * cache->fstop_percent;
+	cache->fcull = stats.f_files * cache->fcull_percent;
+	cache->frun  = stats.f_files * cache->frun_percent;
+
+	_debug("limits {%llu,%llu,%llu} files",
+	       (unsigned long long) cache->frun,
+	       (unsigned long long) cache->fcull,
+	       (unsigned long long) cache->fstop);
+
+	stats.f_blocks >>= cache->bshift;
+	do_div(stats.f_blocks, 100);
+	cache->bstop = stats.f_blocks * cache->bstop_percent;
+	cache->bcull = stats.f_blocks * cache->bcull_percent;
+	cache->brun  = stats.f_blocks * cache->brun_percent;
+
+	_debug("limits {%llu,%llu,%llu} blocks",
+	       (unsigned long long) cache->brun,
+	       (unsigned long long) cache->bcull,
+	       (unsigned long long) cache->bstop);
+
+	/* get the cache directory and check its type */
+	cachedir = cachefiles_get_directory(cache, root, "cache");
+	if (IS_ERR(cachedir)) {
+		ret = PTR_ERR(cachedir);
+		goto error_unsupported;
+	}
+
+	fsdef->dentry = cachedir;
+
+	ret = cachefiles_check_object_type(fsdef);
+	if (ret < 0)
+		goto error_unsupported;
+
+	/* get the graveyard directory */
+	graveyard = cachefiles_get_directory(cache, root, "graveyard");
+	if (IS_ERR(graveyard)) {
+		ret = PTR_ERR(graveyard);
+		goto error_unsupported;
+	}
+
+	cache->graveyard = graveyard;
+
+	/* publish the cache */
+	fscache_init_cache(&cache->cache,
+			   &cachefiles_cache_ops,
+			   "%02x:%02x",
+			   MAJOR(fsdef->dentry->d_sb->s_dev),
+			   MINOR(fsdef->dentry->d_sb->s_dev));
+
+	ret = fscache_add_cache(&cache->cache, &fsdef->fscache, cache->tag);
+	if (ret < 0)
+		goto error_add_cache;
+
+	/* done */
+	set_bit(CACHEFILES_READY, &cache->flags);
+	dput(root);
+
+	printk(KERN_INFO "CacheFiles:"
+	       " File cache on %s registered\n",
+	       cache->cache.identifier);
+
+	/* check how much space the cache has */
+	cachefiles_has_space(cache, 0, 0);
+	cachefiles_end_secure(cache, &secctx);
+	return 0;
+
+error_add_cache:
+	dput(cache->graveyard);
+	cache->graveyard = NULL;
+error_unsupported:
+	mntput(cache->mnt);
+	cache->mnt = NULL;
+	dput(fsdef->dentry);
+	fsdef->dentry = NULL;
+	dput(root);
+error_open_root:
+	kmem_cache_free(cachefiles_object_jar, fsdef);
+error_root_object:
+	cachefiles_end_secure(cache, &secctx);
+	kerror("Failed to register: %d", ret);
+	return ret;
+}
+
+/*
+ * unbind a cache on fd release
+ */
+void cachefiles_daemon_unbind(struct cachefiles_cache *cache)
+{
+	_enter("");
+
+	if (test_bit(CACHEFILES_READY, &cache->flags)) {
+		printk(KERN_INFO "CacheFiles:"
+		       " File cache on %s unregistering\n",
+		       cache->cache.identifier);
+
+		fscache_withdraw_cache(&cache->cache);
+	}
+
+	if (cache->cache.fsdef)
+		cache->cache.ops->put_object(cache->cache.fsdef);
+
+	dput(cache->graveyard);
+	mntput(cache->mnt);
+
+	kfree(cache->rootdirname);
+	kfree(cache->tag);
+
+	_leave("");
+}
diff --git a/fs/cachefiles/cf-daemon.c b/fs/cachefiles/cf-daemon.c
new file mode 100644
index 0000000..1939ff8
--- /dev/null
+++ b/fs/cachefiles/cf-daemon.c
@@ -0,0 +1,720 @@
+/* Daemon interface
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/completion.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/namei.h>
+#include <linux/poll.h>
+#include <linux/mount.h>
+#include <linux/statfs.h>
+#include <linux/ctype.h>
+#include "cf-internal.h"
+
+static int cachefiles_daemon_open(struct inode *, struct file *);
+static int cachefiles_daemon_release(struct inode *, struct file *);
+static ssize_t cachefiles_daemon_read(struct file *, char __user *, size_t, loff_t *);
+static ssize_t cachefiles_daemon_write(struct file *, const char __user *, size_t, loff_t *);
+static unsigned int cachefiles_daemon_poll(struct file *, struct poll_table_struct *);
+static int cachefiles_daemon_frun(struct cachefiles_cache *cache, char *args);
+static int cachefiles_daemon_fcull(struct cachefiles_cache *cache, char *args);
+static int cachefiles_daemon_fstop(struct cachefiles_cache *cache, char *args);
+static int cachefiles_daemon_brun(struct cachefiles_cache *cache, char *args);
+static int cachefiles_daemon_bcull(struct cachefiles_cache *cache, char *args);
+static int cachefiles_daemon_bstop(struct cachefiles_cache *cache, char *args);
+static int cachefiles_daemon_cull(struct cachefiles_cache *cache, char *args);
+static int cachefiles_daemon_debug(struct cachefiles_cache *cache, char *args);
+static int cachefiles_daemon_dir(struct cachefiles_cache *cache, char *args);
+static int cachefiles_daemon_tag(struct cachefiles_cache *cache, char *args);
+static int cachefiles_daemon_inuse(struct cachefiles_cache *cache, char *args);
+
+static unsigned long cachefiles_open;
+
+const struct file_operations cachefiles_daemon_fops = {
+	.owner		= THIS_MODULE,
+	.open		= cachefiles_daemon_open,
+	.release	= cachefiles_daemon_release,
+	.read		= cachefiles_daemon_read,
+	.write		= cachefiles_daemon_write,
+	.poll		= cachefiles_daemon_poll,
+};
+
+struct cachefiles_daemon_cmd {
+	char name[8];
+	int (*handler)(struct cachefiles_cache *cache, char *args);
+};
+
+static const struct cachefiles_daemon_cmd cachefiles_daemon_cmds[] = {
+	{ "bind",	cachefiles_daemon_bind	},
+	{ "brun",	cachefiles_daemon_brun	},
+	{ "bcull",	cachefiles_daemon_bcull	},
+	{ "bstop",	cachefiles_daemon_bstop	},
+	{ "cull",	cachefiles_daemon_cull	},
+	{ "debug",	cachefiles_daemon_debug	},
+	{ "dir",	cachefiles_daemon_dir	},
+	{ "frun",	cachefiles_daemon_frun	},
+	{ "fcull",	cachefiles_daemon_fcull	},
+	{ "fstop",	cachefiles_daemon_fstop	},
+	{ "inuse",	cachefiles_daemon_inuse	},
+	{ "tag",	cachefiles_daemon_tag	},
+	{ "",		NULL			}
+};
+
+
+/*
+ * do various checks
+ */
+static int cachefiles_daemon_open(struct inode *inode, struct file *file)
+{
+	struct cachefiles_cache *cache;
+
+	_enter("");
+
+	/* only the superuser may do this */
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* the cachefiles device may only be open once at a time */
+	if (xchg(&cachefiles_open, 1) == 1)
+		return -EBUSY;
+
+	/* allocate a cache record */
+	cache = kzalloc(sizeof(struct cachefiles_cache), GFP_KERNEL);
+	if (!cache) {
+		cachefiles_open = 0;
+		return -ENOMEM;
+	}
+
+	mutex_init(&cache->daemon_mutex);
+	cache->active_nodes = RB_ROOT;
+	rwlock_init(&cache->active_lock);
+	init_waitqueue_head(&cache->daemon_pollwq);
+
+	/* set default caching limits
+	 * - limit at 1% free space and/or free files
+	 * - cull below 5% free space and/or free files
+	 * - cease culling above 7% free space and/or free files
+	 */
+	cache->frun_percent = 7;
+	cache->fcull_percent = 5;
+	cache->fstop_percent = 1;
+	cache->brun_percent = 7;
+	cache->bcull_percent = 5;
+	cache->bstop_percent = 1;
+
+	file->private_data = cache;
+	cache->cachefilesd = file;
+	return 0;
+}
+
+/*
+ * release a cache
+ */
+static int cachefiles_daemon_release(struct inode *inode, struct file *file)
+{
+	struct cachefiles_cache *cache = file->private_data;
+
+	_enter("");
+
+	ASSERT(cache);
+
+	set_bit(CACHEFILES_DEAD, &cache->flags);
+
+	cachefiles_daemon_unbind(cache);
+
+	ASSERT(!cache->active_nodes.rb_node);
+
+	/* clean up the control file interface */
+	cache->cachefilesd = NULL;
+	file->private_data = NULL;
+	cachefiles_open = 0;
+
+	kfree(cache);
+
+	_leave("");
+	return 0;
+}
+
+/*
+ * read the cache state
+ */
+static ssize_t cachefiles_daemon_read(struct file *file, char __user *_buffer,
+				      size_t buflen, loff_t *pos)
+{
+	struct cachefiles_cache *cache = file->private_data;
+	char buffer[256];
+	int n;
+
+	_enter(",,%zu,", buflen);
+
+	if (!test_bit(CACHEFILES_READY, &cache->flags))
+		return 0;
+
+	/* check how much space the cache has */
+	cachefiles_has_space(cache, 0, 0);
+
+	/* summarise */
+	clear_bit(CACHEFILES_STATE_CHANGED, &cache->flags);
+
+	n = snprintf(buffer, sizeof(buffer),
+		     "cull=%c"
+		     " frun=%llx"
+		     " fcull=%llx"
+		     " fstop=%llx"
+		     " brun=%llx"
+		     " bcull=%llx"
+		     " bstop=%llx",
+		     test_bit(CACHEFILES_CULLING, &cache->flags) ? '1' : '0',
+		     (unsigned long long) cache->frun,
+		     (unsigned long long) cache->fcull,
+		     (unsigned long long) cache->fstop,
+		     (unsigned long long) cache->brun,
+		     (unsigned long long) cache->bcull,
+		     (unsigned long long) cache->bstop
+		     );
+
+	if (n > buflen)
+		return -EMSGSIZE;
+
+	if (copy_to_user(_buffer, buffer, n) != 0)
+		return -EFAULT;
+
+	return n;
+}
+
+/*
+ * command the cache
+ */
+static ssize_t cachefiles_daemon_write(struct file *file,
+				       const char __user *_data,
+				       size_t datalen,
+				       loff_t *pos)
+{
+	const struct cachefiles_daemon_cmd *cmd;
+	struct cachefiles_cache *cache = file->private_data;
+	ssize_t ret;
+	char *data, *args, *cp;
+
+	_enter(",,%zu,", datalen);
+
+	ASSERT(cache);
+
+	if (test_bit(CACHEFILES_DEAD, &cache->flags))
+		return -EIO;
+
+	if (datalen < 0 || datalen > PAGE_SIZE - 1)
+		return -EOPNOTSUPP;
+
+	/* drag the command string into the kernel so we can parse it */
+	data = kmalloc(datalen + 1, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	ret = -EFAULT;
+	if (copy_from_user(data, _data, datalen) != 0)
+		goto error;
+
+	data[datalen] = '\0';
+
+	ret = -EINVAL;
+	if (memchr(data, '\0', datalen))
+		goto error;
+
+	/* strip any newline */
+	cp = memchr(data, '\n', datalen);
+	if (cp) {
+		if (cp == data)
+			goto error;
+
+		*cp = '\0';
+	}
+
+	/* parse the command */
+	ret = -EOPNOTSUPP;
+
+	for (args = data; *args; args++)
+		if (isspace(*args))
+			break;
+	if (*args) {
+		if (args == data)
+			goto error;
+		*args = '\0';
+		for (args++; isspace(*args); args++)
+			continue;
+	}
+
+	/* run the appropriate command handler */
+	for (cmd = cachefiles_daemon_cmds; cmd->name[0]; cmd++)
+		if (strcmp(cmd->name, data) == 0)
+			goto found_command;
+
+error:
+	kfree(data);
+	_leave(" = %zd", ret);
+	return ret;
+
+found_command:
+	mutex_lock(&cache->daemon_mutex);
+
+	ret = -EIO;
+	if (!test_bit(CACHEFILES_DEAD, &cache->flags))
+		ret = cmd->handler(cache, args);
+
+	mutex_unlock(&cache->daemon_mutex);
+
+	if (ret == 0)
+		ret = datalen;
+	goto error;
+}
+
+/*
+ * poll for culling state
+ * - use POLLOUT to indicate culling state
+ */
+static unsigned int cachefiles_daemon_poll(struct file *file,
+					   struct poll_table_struct *poll)
+{
+	struct cachefiles_cache *cache = file->private_data;
+	unsigned int mask;
+
+	poll_wait(file, &cache->daemon_pollwq, poll);
+	mask = 0;
+
+	if (test_bit(CACHEFILES_STATE_CHANGED, &cache->flags))
+		mask |= POLLIN;
+
+	if (test_bit(CACHEFILES_CULLING, &cache->flags))
+		mask |= POLLOUT;
+
+	return mask;
+}
+
+/*
+ * give a range error for cache space constraints
+ * - can be tail-called
+ */
+static int cachefiles_daemon_range_error(struct cachefiles_cache *cache, char *args)
+{
+	kerror("Free space limits must be in range"
+	       " 0%%<=stop<cull<run<100%%");
+
+	return -EINVAL;
+}
+
+/*
+ * set the percentage of files at which to stop culling
+ * - command: "frun <N>%"
+ */
+static int cachefiles_daemon_frun(struct cachefiles_cache *cache, char *args)
+{
+	unsigned long frun;
+
+	_enter(",%s", args);
+
+	if (!*args)
+		return -EINVAL;
+
+	frun = simple_strtoul(args, &args, 10);
+	if (args[0] != '%' || args[1] != '\0')
+		return -EINVAL;
+
+	if (frun <= cache->fcull_percent || frun >= 100)
+		return cachefiles_daemon_range_error(cache, args);
+
+	cache->frun_percent = frun;
+	return 0;
+}
+
+/*
+ * set the percentage of files at which to start culling
+ * - command: "fcull <N>%"
+ */
+static int cachefiles_daemon_fcull(struct cachefiles_cache *cache, char *args)
+{
+	unsigned long fcull;
+
+	_enter(",%s", args);
+
+	if (!*args)
+		return -EINVAL;
+
+	fcull = simple_strtoul(args, &args, 10);
+	if (args[0] != '%' || args[1] != '\0')
+		return -EINVAL;
+
+	if (fcull <= cache->fstop_percent || fcull >= cache->frun_percent)
+		return cachefiles_daemon_range_error(cache, args);
+
+	cache->fcull_percent = fcull;
+	return 0;
+}
+
+/*
+ * set the percentage of files at which to stop allocating
+ * - command: "fstop <N>%"
+ */
+static int cachefiles_daemon_fstop(struct cachefiles_cache *cache, char *args)
+{
+	unsigned long fstop;
+
+	_enter(",%s", args);
+
+	if (!*args)
+		return -EINVAL;
+
+	fstop = simple_strtoul(args, &args, 10);
+	if (args[0] != '%' || args[1] != '\0')
+		return -EINVAL;
+
+	if (fstop < 0 || fstop >= cache->fcull_percent)
+		return cachefiles_daemon_range_error(cache, args);
+
+	cache->fstop_percent = fstop;
+	return 0;
+}
+
+/*
+ * set the percentage of blocks at which to stop culling
+ * - command: "brun <N>%"
+ */
+static int cachefiles_daemon_brun(struct cachefiles_cache *cache, char *args)
+{
+	unsigned long brun;
+
+	_enter(",%s", args);
+
+	if (!*args)
+		return -EINVAL;
+
+	brun = simple_strtoul(args, &args, 10);
+	if (args[0] != '%' || args[1] != '\0')
+		return -EINVAL;
+
+	if (brun <= cache->bcull_percent || brun >= 100)
+		return cachefiles_daemon_range_error(cache, args);
+
+	cache->brun_percent = brun;
+	return 0;
+}
+
+/*
+ * set the percentage of blocks at which to start culling
+ * - command: "bcull <N>%"
+ */
+static int cachefiles_daemon_bcull(struct cachefiles_cache *cache, char *args)
+{
+	unsigned long bcull;
+
+	_enter(",%s", args);
+
+	if (!*args)
+		return -EINVAL;
+
+	bcull = simple_strtoul(args, &args, 10);
+	if (args[0] != '%' || args[1] != '\0')
+		return -EINVAL;
+
+	if (bcull <= cache->bstop_percent || bcull >= cache->brun_percent)
+		return cachefiles_daemon_range_error(cache, args);
+
+	cache->bcull_percent = bcull;
+	return 0;
+}
+
+/*
+ * set the percentage of blocks at which to stop allocating
+ * - command: "bstop <N>%"
+ */
+static int cachefiles_daemon_bstop(struct cachefiles_cache *cache, char *args)
+{
+	unsigned long bstop;
+
+	_enter(",%s", args);
+
+	if (!*args)
+		return -EINVAL;
+
+	bstop = simple_strtoul(args, &args, 10);
+	if (args[0] != '%' || args[1] != '\0')
+		return -EINVAL;
+
+	if (bstop < 0 || bstop >= cache->bcull_percent)
+		return cachefiles_daemon_range_error(cache, args);
+
+	cache->bstop_percent = bstop;
+	return 0;
+}
+
+/*
+ * set the cache directory
+ * - command: "dir <name>"
+ */
+static int cachefiles_daemon_dir(struct cachefiles_cache *cache, char *args)
+{
+	char *dir;
+
+	_enter(",%s", args);
+
+	if (!*args) {
+		kerror("Empty directory specified");
+		return -EINVAL;
+	}
+
+	if (cache->rootdirname) {
+		kerror("Second cache directory specified");
+		return -EEXIST;
+	}
+
+	dir = kstrdup(args, GFP_KERNEL);
+	if (!dir)
+		return -ENOMEM;
+
+	cache->rootdirname = dir;
+	return 0;
+}
+
+/*
+ * set the cache tag
+ * - command: "tag <name>"
+ */
+static int cachefiles_daemon_tag(struct cachefiles_cache *cache, char *args)
+{
+	char *tag;
+
+	_enter(",%s", args);
+
+	if (!*args) {
+		kerror("Empty tag specified");
+		return -EINVAL;
+	}
+
+	if (cache->tag)
+		return -EEXIST;
+
+	tag = kstrdup(args, GFP_KERNEL);
+	if (!tag)
+		return -ENOMEM;
+
+	cache->tag = tag;
+	return 0;
+}
+
+/*
+ * request a node in the cache be culled from the current working directory
+ * - command: "cull <name>"
+ */
+static int cachefiles_daemon_cull(struct cachefiles_cache *cache, char *args)
+{
+	struct cachefiles_secctx secctx;
+	struct fs_struct *fs;
+	struct dentry *dir;
+	int ret;
+
+	_enter(",%s", args);
+
+	if (strchr(args, '/'))
+		goto inval;
+
+	if (!test_bit(CACHEFILES_READY, &cache->flags)) {
+		kerror("cull applied to unready cache");
+		return -EIO;
+	}
+
+	if (test_bit(CACHEFILES_DEAD, &cache->flags)) {
+		kerror("cull applied to dead cache");
+		return -EIO;
+	}
+
+	/* extract the directory dentry from the cwd */
+	fs = current->fs;
+	read_lock(&fs->lock);
+	dir = dget(fs->pwd);
+	read_unlock(&fs->lock);
+
+	if (!S_ISDIR(dir->d_inode->i_mode))
+		goto notdir;
+
+	cachefiles_begin_secure(cache, &secctx);
+	ret = cachefiles_cull(cache, dir, args);
+	cachefiles_end_secure(cache, &secctx);
+
+	dput(dir);
+	_leave(" = %d", ret);
+	return ret;
+
+notdir:
+	dput(dir);
+	kerror("cull command requires dirfd to be a directory");
+	return -ENOTDIR;
+
+inval:
+	kerror("cull command requires dirfd and filename");
+	return -EINVAL;
+}
+
+/*
+ * set debugging mode
+ * - command: "debug <mask>"
+ */
+static int cachefiles_daemon_debug(struct cachefiles_cache *cache, char *args)
+{
+	unsigned long mask;
+
+	_enter(",%s", args);
+
+	mask = simple_strtoul(args, &args, 0);
+	if (args[0] != '\0')
+		goto inval;
+
+	cachefiles_debug = mask;
+	_leave(" = 0");
+	return 0;
+
+inval:
+	kerror("debug command requires mask");
+	return -EINVAL;
+}
+
+/*
+ * find out whether an object in the current working directory is in use or not
+ * - command: "inuse <name>"
+ */
+static int cachefiles_daemon_inuse(struct cachefiles_cache *cache, char *args)
+{
+	struct cachefiles_secctx secctx;
+	struct fs_struct *fs;
+	struct dentry *dir;
+	int ret;
+
+	_enter(",%s", args);
+
+	if (strchr(args, '/'))
+		goto inval;
+
+	if (!test_bit(CACHEFILES_READY, &cache->flags)) {
+		kerror("inuse applied to unready cache");
+		return -EIO;
+	}
+
+	if (test_bit(CACHEFILES_DEAD, &cache->flags)) {
+		kerror("inuse applied to dead cache");
+		return -EIO;
+	}
+
+	/* extract the directory dentry from the cwd */
+	fs = current->fs;
+	read_lock(&fs->lock);
+	dir = dget(fs->pwd);
+	read_unlock(&fs->lock);
+
+	if (!S_ISDIR(dir->d_inode->i_mode))
+		goto notdir;
+
+	cachefiles_begin_secure(cache, &secctx);
+	ret = cachefiles_check_in_use(cache, dir, args);
+	cachefiles_end_secure(cache, &secctx);
+
+	dput(dir);
+	_leave(" = %d", ret);
+	return ret;
+
+notdir:
+	dput(dir);
+	kerror("inuse command requires dirfd to be a directory");
+	return -ENOTDIR;
+
+inval:
+	kerror("inuse command requires dirfd and filename");
+	return -EINVAL;
+}
+
+/*
+ * see if we have space for a number of pages and/or a number of files in the
+ * cache
+ */
+int cachefiles_has_space(struct cachefiles_cache *cache,
+			 unsigned fnr, unsigned bnr)
+{
+	struct kstatfs stats;
+	int ret;
+
+	_enter("{%llu,%llu,%llu,%llu,%llu,%llu},%u,%u",
+	       (unsigned long long) cache->frun,
+	       (unsigned long long) cache->fcull,
+	       (unsigned long long) cache->fstop,
+	       (unsigned long long) cache->brun,
+	       (unsigned long long) cache->bcull,
+	       (unsigned long long) cache->bstop,
+	       fnr, bnr);
+
+	/* find out how many pages of blockdev are available */
+	memset(&stats, 0, sizeof(stats));
+
+	ret = vfs_statfs(cache->mnt->mnt_root, &stats);
+	if (ret < 0) {
+		if (ret == -EIO)
+			cachefiles_io_error(cache, "statfs failed");
+		_leave(" = %d", ret);
+		return ret;
+	}
+
+	stats.f_bavail >>= cache->bshift;
+
+	_debug("avail %llu,%llu",
+	       (unsigned long long) stats.f_ffree,
+	       (unsigned long long) stats.f_bavail);
+
+	/* see if there is sufficient space */
+	if (stats.f_ffree > fnr)
+		stats.f_ffree -= fnr;
+	else
+		stats.f_ffree = 0;
+
+	if (stats.f_bavail > bnr)
+		stats.f_bavail -= bnr;
+	else
+		stats.f_bavail = 0;
+
+	ret = -ENOBUFS;
+	if (stats.f_ffree < cache->fstop ||
+	    stats.f_bavail < cache->bstop)
+		goto begin_cull;
+
+	ret = 0;
+	if (stats.f_ffree < cache->fcull ||
+	    stats.f_bavail < cache->bcull)
+		goto begin_cull;
+
+	if (test_bit(CACHEFILES_CULLING, &cache->flags) &&
+	    stats.f_ffree >= cache->frun &&
+	    stats.f_bavail >= cache->brun &&
+	    test_and_clear_bit(CACHEFILES_CULLING, &cache->flags)
+	    ) {
+		_debug("cease culling");
+		cachefiles_state_changed(cache);
+	}
+
+	_leave(" = 0");
+	return 0;
+
+begin_cull:
+	if (!test_and_set_bit(CACHEFILES_CULLING, &cache->flags)) {
+		_debug("### CULL CACHE ###");
+		cachefiles_state_changed(cache);
+	}
+
+	_leave(" = %d", ret);
+	return ret;
+}
diff --git a/fs/cachefiles/cf-interface.c b/fs/cachefiles/cf-interface.c
new file mode 100644
index 0000000..4f29f21
--- /dev/null
+++ b/fs/cachefiles/cf-interface.c
@@ -0,0 +1,442 @@
+/* FS-Cache interface to CacheFiles
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/mount.h>
+#include <linux/buffer_head.h>
+#include "cf-internal.h"
+
+#define list_to_page(head) (list_entry((head)->prev, struct page, lru))
+
+struct cachefiles_lookup_data {
+	struct cachefiles_xattr	*auxdata;	/* auxiliary data */
+	char			*key;		/* key path */
+};
+
+static int cachefiles_attr_changed(struct fscache_object *_object);
+
+/*
+ * allocate an object record for a cookie lookup and prepare the lookup data
+ */
+static struct fscache_object *cachefiles_alloc_object(
+	struct fscache_cache *_cache,
+	struct fscache_cookie *cookie)
+{
+	struct cachefiles_lookup_data *lookup_data;
+	struct cachefiles_object *object;
+	struct cachefiles_cache *cache;
+	struct cachefiles_xattr *auxdata;
+	unsigned keylen, auxlen;
+	void *buffer;
+	char *key;
+
+	cache = container_of(_cache, struct cachefiles_cache, cache);
+
+	_enter("{%s},%p,", cache->cache.identifier, cookie);
+
+	lookup_data = kmalloc(sizeof(lookup_data), GFP_KERNEL);
+	if (!lookup_data)
+		goto nomem_lookup_data;
+
+	/* create a new object record and a temporary leaf image */
+	object = kmem_cache_alloc(cachefiles_object_jar, GFP_KERNEL);
+	if (!object)
+		goto nomem_object;
+
+	ASSERTCMP(object->backer, ==, NULL);
+
+	BUG_ON(test_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags));
+	atomic_set(&object->usage, 1);
+
+	fscache_object_init(&object->fscache);
+	object->fscache.cookie = cookie;
+	object->fscache.cache = &cache->cache;
+
+	object->type = cookie->def->type;
+
+	/* get hold of the raw key
+	 * - stick the length on the front and leave space on the back for the
+	 *   encoder
+	 */
+	buffer = kmalloc((2 + 512) + 3, GFP_KERNEL);
+	if (!buffer)
+		goto nomem_buffer;
+
+	keylen = cookie->def->get_key(cookie->netfs_data, buffer + 2, 512);
+	ASSERTCMP(keylen, <, 512);
+
+	*(uint16_t *)buffer = keylen;
+	((char *)buffer)[keylen + 2] = 0;
+	((char *)buffer)[keylen + 3] = 0;
+	((char *)buffer)[keylen + 4] = 0;
+
+	/* turn the raw key into something that can work with as a filename */
+	key = cachefiles_cook_key(buffer, keylen + 2, object->type);
+	if (!key)
+		goto nomem_key;
+
+	/* get hold of the auxiliary data and prepend the object type */
+	auxdata = buffer;
+	auxlen = 0;
+	if (cookie->def->get_aux) {
+		auxlen = cookie->def->get_aux(cookie->netfs_data,
+					      auxdata->data, 511);
+		ASSERTCMP(auxlen, <, 511);
+	}
+
+	auxdata->len = auxlen + 1;
+	auxdata->type = cookie->def->type;
+
+	lookup_data->auxdata = auxdata;
+	lookup_data->key = key;
+	object->lookup_data = lookup_data;
+
+	_leave(" = %p [%p]", &object->fscache, lookup_data);
+	return &object->fscache;
+
+nomem_key:
+	kfree(buffer);
+nomem_buffer:
+	BUG_ON(test_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags));
+	kmem_cache_free(cachefiles_object_jar, object);
+nomem_object:
+	kfree(lookup_data);
+nomem_lookup_data:
+	_leave(" = -ENOMEM");
+	return ERR_PTR(-ENOMEM);
+}
+
+/*
+ * attempt to look up the nominated node in this cache
+ */
+static void cachefiles_lookup_object(struct fscache_object *_object)
+{
+	struct cachefiles_lookup_data *lookup_data;
+	struct cachefiles_object *parent, *object;
+	struct cachefiles_secctx secctx;
+	struct cachefiles_cache *cache;
+	int ret;
+
+	_enter("{OBJ%x}", _object->debug_id);
+
+	cache = container_of(_object->cache, struct cachefiles_cache, cache);
+	parent = container_of(_object->parent,
+			      struct cachefiles_object, fscache);
+	object = container_of(_object, struct cachefiles_object, fscache);
+	lookup_data = object->lookup_data;
+
+	ASSERTCMP(lookup_data, !=, NULL);
+
+	/* look up the key, creating any missing bits */
+	cachefiles_begin_secure(cache, &secctx);
+	ret = cachefiles_walk_to_object(parent, object,
+					lookup_data->key,
+					lookup_data->auxdata);
+	cachefiles_end_secure(cache, &secctx);
+
+	/* polish off by setting the attributes of non-index files */
+	if (ret == 0 &&
+	    object->fscache.cookie->def->type != FSCACHE_COOKIE_TYPE_INDEX)
+		cachefiles_attr_changed(&object->fscache);
+
+	if (ret < 0)
+		fscache_object_lookup_error(&object->fscache);
+
+	_leave(" [%d]", ret);
+}
+
+/*
+ * indication of lookup completion
+ */
+static void cachefiles_lookup_complete(struct fscache_object *_object)
+{
+	struct cachefiles_object *object;
+
+	object = container_of(_object, struct cachefiles_object, fscache);
+
+	_enter("{OBJ%x,%p}", object->fscache.debug_id, object->lookup_data);
+
+	if (object->lookup_data) {
+		kfree(object->lookup_data->key);
+		kfree(object->lookup_data->auxdata);
+		kfree(object->lookup_data);
+		object->lookup_data = NULL;
+	}
+}
+
+/*
+ * increment the usage count on an inode object (may fail if unmounting)
+ */
+static struct fscache_object *cachefiles_grab_object(struct fscache_object *_object)
+{
+	struct cachefiles_object *object;
+
+	_enter("{OBJ%x}", _object->debug_id);
+
+	object = container_of(_object, struct cachefiles_object, fscache);
+
+#ifdef CACHEFILES_DEBUG_SLAB
+	ASSERT((atomic_read(&object->usage) & 0xffff0000) != 0x6b6b0000);
+#endif
+
+	atomic_inc(&object->usage);
+	return &object->fscache;
+}
+
+/*
+ * update the auxilliary data for an object object on disk
+ */
+static void cachefiles_update_object(struct fscache_object *_object)
+{
+	struct cachefiles_secctx secctx;
+	struct cachefiles_object *object;
+	struct cachefiles_xattr *auxdata;
+	struct cachefiles_cache *cache;
+	struct fscache_cookie *cookie;
+	unsigned auxlen;
+
+	_enter("{OBJ%x}", _object->debug_id);
+
+	object = container_of(_object, struct cachefiles_object, fscache);
+	cache = container_of(object->fscache.cache, struct cachefiles_cache,
+			     cache);
+	cookie = object->fscache.cookie;
+
+	if (!cookie->def->get_aux) {
+		_leave(" [no aux]");
+		return;
+	}
+
+	auxdata = kmalloc(2 + 512 + 3, GFP_KERNEL);
+	if (!auxdata) {
+		_leave(" [nomem]");
+		return;
+	}
+
+	auxlen = cookie->def->get_aux(cookie->netfs_data, auxdata->data, 511);
+	ASSERTCMP(auxlen, <, 511);
+
+	auxdata->len = auxlen + 1;
+	auxdata->type = cookie->def->type;
+
+	cachefiles_begin_secure(cache, &secctx);
+	cachefiles_update_object_xattr(object, auxdata);
+	cachefiles_end_secure(cache, &secctx);
+	kfree(auxdata);
+	_leave("");
+}
+
+/*
+ * discard the resources pinned by an object and effect retirement if
+ * requested
+ */
+static void cachefiles_drop_object(struct fscache_object *_object)
+{
+	struct cachefiles_secctx secctx;
+	struct cachefiles_object *object;
+	struct cachefiles_cache *cache;
+
+	ASSERT(_object);
+
+	object = container_of(_object, struct cachefiles_object, fscache);
+
+	_enter("{OBJ%x,%d}",
+	       object->fscache.debug_id, atomic_read(&object->usage));
+
+	cache = container_of(object->fscache.cache,
+			     struct cachefiles_cache, cache);
+
+#ifdef CACHEFILES_DEBUG_SLAB
+	ASSERT((atomic_read(&object->usage) & 0xffff0000) != 0x6b6b0000);
+#endif
+
+	/* delete retired objects */
+	if (object->fscache.state == FSCACHE_OBJECT_RECYCLING &&
+	    _object != cache->cache.fsdef
+	    ) {
+		_debug("- retire object OBJ%x", object->fscache.debug_id);
+		cachefiles_begin_secure(cache, &secctx);
+		cachefiles_delete_object(cache, object);
+		cachefiles_end_secure(cache, &secctx);
+	}
+
+	/* close the filesystem stuff attached to the object */
+	if (object->backer != object->dentry)
+		dput(object->backer);
+	object->backer = NULL;
+
+	/* note that the object is now inactive */
+	if (test_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags)) {
+		write_lock(&cache->active_lock);
+		if (!test_and_clear_bit(CACHEFILES_OBJECT_ACTIVE,
+					&object->flags))
+			BUG();
+		rb_erase(&object->active_node, &cache->active_nodes);
+		wake_up_bit(&object->flags, CACHEFILES_OBJECT_ACTIVE);
+		write_unlock(&cache->active_lock);
+	}
+
+	dput(object->dentry);
+	object->dentry = NULL;
+
+	_leave("");
+}
+
+/*
+ * dispose of a reference to an object
+ */
+static void cachefiles_put_object(struct fscache_object *_object)
+{
+	struct cachefiles_object *object;
+
+	ASSERT(_object);
+
+	object = container_of(_object, struct cachefiles_object, fscache);
+
+	_enter("{OBJ%x,%d}",
+	       object->fscache.debug_id, atomic_read(&object->usage));
+
+#ifdef CACHEFILES_DEBUG_SLAB
+	ASSERT((atomic_read(&object->usage) & 0xffff0000) != 0x6b6b0000);
+#endif
+
+	ASSERTIFCMP(object->fscache.parent,
+		    object->fscache.parent->n_children, >, 0);
+
+	if (atomic_dec_and_test(&object->usage)) {
+		_debug("- kill object OBJ%x", object->fscache.debug_id);
+
+		ASSERT(!test_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags));
+		ASSERTCMP(object->fscache.parent, ==, NULL);
+		ASSERTCMP(object->backer, ==, NULL);
+		ASSERTCMP(object->dentry, ==, NULL);
+		ASSERTCMP(object->fscache.n_ops, ==, 0);
+		ASSERTCMP(object->fscache.n_children, ==, 0);
+
+		if (object->lookup_data) {
+			kfree(object->lookup_data->key);
+			kfree(object->lookup_data->auxdata);
+			kfree(object->lookup_data);
+			object->lookup_data = NULL;
+		}
+
+		kmem_cache_free(cachefiles_object_jar, object);
+	}
+
+	_leave("");
+}
+
+/*
+ * sync a cache
+ */
+static void cachefiles_sync_cache(struct fscache_cache *_cache)
+{
+	struct cachefiles_secctx secctx;
+	struct cachefiles_cache *cache;
+	int ret;
+
+	_enter("%p", _cache);
+
+	cache = container_of(_cache, struct cachefiles_cache, cache);
+
+	/* make sure all pages pinned by operations on behalf of the netfs are
+	 * written to disc */
+	cachefiles_begin_secure(cache, &secctx);
+	ret = fsync_super(cache->mnt->mnt_sb);
+	cachefiles_end_secure(cache, &secctx);
+
+	if (ret == -EIO)
+		cachefiles_io_error(cache,
+				    "Attempt to sync backing fs superblock"
+				    " returned error %d",
+				    ret);
+}
+
+/*
+ * notification the attributes on an object have changed
+ * - called with reads/writes excluded by FS-Cache
+ */
+static int cachefiles_attr_changed(struct fscache_object *_object)
+{
+	struct cachefiles_secctx secctx;
+	struct cachefiles_object *object;
+	struct cachefiles_cache *cache;
+	struct iattr newattrs;
+	loff_t ni_size, oi_size;
+	int ret;
+
+	_object->cookie->def->get_attr(_object->cookie->netfs_data, &ni_size);
+
+	_enter("{OBJ%x},[%llu]", _object->debug_id, ni_size);
+
+	object = container_of(_object, struct cachefiles_object, fscache);
+	cache = container_of(object->fscache.cache,
+			     struct cachefiles_cache, cache);
+
+	if (ni_size == object->i_size)
+		return 0;
+
+	if (!object->backer)
+		return -ENOBUFS;
+
+	ASSERT(S_ISREG(object->backer->d_inode->i_mode));
+
+	fscache_set_store_limit(&object->fscache, ni_size);
+
+	oi_size = i_size_read(object->backer->d_inode);
+	if (oi_size == ni_size)
+		return 0;
+
+	newattrs.ia_size = ni_size;
+	newattrs.ia_valid = ATTR_SIZE;
+
+	cachefiles_begin_secure(cache, &secctx);
+	mutex_lock(&object->backer->d_inode->i_mutex);
+	ret = notify_change(object->backer, &newattrs);
+	mutex_unlock(&object->backer->d_inode->i_mutex);
+	cachefiles_end_secure(cache, &secctx);
+
+	if (ret == -EIO) {
+		fscache_set_store_limit(&object->fscache, 0);
+		cachefiles_io_error_obj(object, "Size set failed");
+		ret = -ENOBUFS;
+	}
+
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * dissociate a cache from all the pages it was backing
+ */
+static void cachefiles_dissociate_pages(struct fscache_cache *cache)
+{
+	_enter("");
+}
+
+const struct fscache_cache_ops cachefiles_cache_ops = {
+	.name			= "cachefiles",
+	.alloc_object		= cachefiles_alloc_object,
+	.lookup_object		= cachefiles_lookup_object,
+	.lookup_complete	= cachefiles_lookup_complete,
+	.grab_object		= cachefiles_grab_object,
+	.update_object		= cachefiles_update_object,
+	.drop_object		= cachefiles_drop_object,
+	.put_object		= cachefiles_put_object,
+	.sync_cache		= cachefiles_sync_cache,
+	.attr_changed		= cachefiles_attr_changed,
+	.read_or_alloc_page	= cachefiles_read_or_alloc_page,
+	.read_or_alloc_pages	= cachefiles_read_or_alloc_pages,
+	.allocate_page		= cachefiles_allocate_page,
+	.allocate_pages		= cachefiles_allocate_pages,
+	.write_page		= cachefiles_write_page,
+	.uncache_page		= cachefiles_uncache_page,
+	.dissociate_pages	= cachefiles_dissociate_pages,
+};
diff --git a/fs/cachefiles/cf-internal.h b/fs/cachefiles/cf-internal.h
new file mode 100644
index 0000000..dafddcf
--- /dev/null
+++ b/fs/cachefiles/cf-internal.h
@@ -0,0 +1,420 @@
+/* General netfs cache on cache files internal defs
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/fscache-cache.h>
+#include <linux/timer.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+#include <linux/security.h>
+
+struct cachefiles_cache;
+struct cachefiles_object;
+
+extern unsigned cachefiles_debug;
+#define CACHEFILES_DEBUG_KENTER	1
+#define CACHEFILES_DEBUG_KLEAVE	2
+#define CACHEFILES_DEBUG_KDEBUG	4
+
+/*
+ * node records
+ */
+struct cachefiles_object {
+	struct fscache_object		fscache;	/* fscache handle */
+	struct cachefiles_lookup_data	*lookup_data;	/* cached lookup data */
+	struct dentry			*dentry;	/* the file/dir representing this object */
+	struct dentry			*backer;	/* backing file */
+	loff_t				i_size;		/* object size */
+	unsigned long			flags;
+#define CACHEFILES_OBJECT_ACTIVE	0		/* T if marked active */
+	atomic_t			usage;		/* object usage count */
+	uint8_t				type;		/* object type */
+	uint8_t				new;		/* T if object new */
+	spinlock_t			work_lock;
+	struct rb_node			active_node;	/* link in active tree (dentry is key) */
+};
+
+extern struct kmem_cache *cachefiles_object_jar;
+
+/*
+ * Cache files cache definition
+ */
+struct cachefiles_cache {
+	struct fscache_cache		cache;		/* FS-Cache record */
+	struct vfsmount			*mnt;		/* mountpoint holding the cache */
+	struct dentry			*graveyard;	/* directory into which dead objects go */
+	struct file			*cachefilesd;	/* manager daemon handle */
+	struct mutex			daemon_mutex;	/* command serialisation mutex */
+	wait_queue_head_t		daemon_pollwq;	/* poll waitqueue for daemon */
+	struct rb_root			active_nodes;	/* active nodes (can't be culled) */
+	rwlock_t			active_lock;	/* lock for active_nodes */
+	atomic_t			gravecounter;	/* graveyard uniquifier */
+	u32				access_secid;	/* cache access security ID */
+	u32				cache_secid;	/* cache fs object security ID */
+	unsigned			frun_percent;	/* when to stop culling (% files) */
+	unsigned			fcull_percent;	/* when to start culling (% files) */
+	unsigned			fstop_percent;	/* when to stop allocating (% files) */
+	unsigned			brun_percent;	/* when to stop culling (% blocks) */
+	unsigned			bcull_percent;	/* when to start culling (% blocks) */
+	unsigned			bstop_percent;	/* when to stop allocating (% blocks) */
+	unsigned			bsize;		/* cache's block size */
+	unsigned			bshift;		/* min(ilog2(PAGE_SIZE / bsize), 0) */
+	uint64_t			frun;		/* when to stop culling */
+	uint64_t			fcull;		/* when to start culling */
+	uint64_t			fstop;		/* when to stop allocating */
+	sector_t			brun;		/* when to stop culling */
+	sector_t			bcull;		/* when to start culling */
+	sector_t			bstop;		/* when to stop allocating */
+	unsigned long			flags;
+#define CACHEFILES_READY		0	/* T if cache prepared */
+#define CACHEFILES_DEAD			1	/* T if cache dead */
+#define CACHEFILES_CULLING		2	/* T if cull engaged */
+#define CACHEFILES_STATE_CHANGED	3	/* T if state changed (poll trigger) */
+	char				*rootdirname;	/* name of cache root directory */
+	char				*tag;		/* cache binding tag */
+};
+
+/*
+ * backing file read tracking
+ */
+struct cachefiles_one_read {
+	wait_queue_t			monitor;	/* link into monitored waitqueue */
+	struct page			*back_page;	/* backing file page we're waiting for */
+	struct page			*netfs_page;	/* netfs page we're going to fill */
+	struct fscache_retrieval	*op;		/* retrieval op covering this */
+	struct list_head		op_link;	/* link in op's todo list */
+};
+
+/*
+ * backing file write tracking
+ */
+struct cachefiles_one_write {
+	struct page			*netfs_page;	/* netfs page to copy */
+	struct cachefiles_object	*object;
+	struct list_head		obj_link;	/* link in object's lists */
+	fscache_rw_complete_t		end_io_func;
+	void				*context;
+};
+
+/*
+ * auxiliary data xattr buffer
+ */
+struct cachefiles_xattr {
+	uint16_t			len;
+	uint8_t				type;
+	uint8_t				data[];
+};
+
+/*
+ * note change of state for daemon
+ */
+static inline void cachefiles_state_changed(struct cachefiles_cache *cache)
+{
+	set_bit(CACHEFILES_STATE_CHANGED, &cache->flags);
+	wake_up_all(&cache->daemon_pollwq);
+}
+
+/*
+ * cf-bind.c
+ */
+extern int cachefiles_daemon_bind(struct cachefiles_cache *cache, char *args);
+extern void cachefiles_daemon_unbind(struct cachefiles_cache *cache);
+
+/*
+ * cf-daemon.c
+ */
+extern const struct file_operations cachefiles_daemon_fops;
+
+extern int cachefiles_has_space(struct cachefiles_cache *cache,
+				unsigned fnr, unsigned bnr);
+
+/*
+ * cf-interface.c
+ */
+extern const struct fscache_cache_ops cachefiles_cache_ops;
+
+/*
+ * cf-key.c
+ */
+extern char *cachefiles_cook_key(const u8 *raw, int keylen, uint8_t type);
+
+/*
+ * cf-namei.c
+ */
+extern int cachefiles_delete_object(struct cachefiles_cache *cache,
+				    struct cachefiles_object *object);
+extern int cachefiles_walk_to_object(struct cachefiles_object *parent,
+				     struct cachefiles_object *object,
+				     const char *key,
+				     struct cachefiles_xattr *auxdata);
+extern struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
+					       struct dentry *dir,
+					       const char *name);
+
+extern int cachefiles_cull(struct cachefiles_cache *cache, struct dentry *dir,
+			   char *filename);
+
+extern int cachefiles_check_in_use(struct cachefiles_cache *cache,
+				   struct dentry *dir, char *filename);
+
+/*
+ * cf-proc.c
+ */
+#ifdef CONFIG_CACHEFILES_HISTOGRAM
+extern atomic_t cachefiles_lookup_histogram[HZ];
+extern atomic_t cachefiles_mkdir_histogram[HZ];
+extern atomic_t cachefiles_create_histogram[HZ];
+
+extern int __init cachefiles_proc_init(void);
+extern void cachefiles_proc_cleanup(void);
+static inline
+void cachefiles_hist(atomic_t histogram[], unsigned long start_jif)
+{
+	unsigned long jif = jiffies - start_jif;
+	if (jif >= HZ)
+		jif = HZ - 1;
+	atomic_inc(&histogram[jif]);
+}
+
+#else
+#define cachefiles_proc_init()		(0)
+#define cachefiles_proc_cleanup()	do {} while(0)
+#define cachefiles_hist(hist, start_jif) do {} while(0)
+#endif
+
+/*
+ * cf-rdwr.c
+ */
+extern int cachefiles_read_or_alloc_page(struct fscache_retrieval *,
+					 struct page *, gfp_t);
+extern int cachefiles_read_or_alloc_pages(struct fscache_retrieval *,
+					  struct list_head *, unsigned *,
+					  gfp_t);
+extern int cachefiles_allocate_page(struct fscache_retrieval *, struct page *,
+				    gfp_t);
+extern int cachefiles_allocate_pages(struct fscache_retrieval *,
+				     struct list_head *, unsigned *, gfp_t);
+extern int cachefiles_write_page(struct fscache_storage *, struct page *);
+extern void cachefiles_uncache_page(struct fscache_object *, struct page *);
+
+/*
+ * cf-security.c
+ */
+#ifdef CONFIG_SECURITY
+extern int cachefiles_get_security_ID(struct cachefiles_cache *cache);
+extern int cachefiles_determine_cache_secid(struct cachefiles_cache *cache,
+					    struct dentry *root);
+static inline
+void cachefiles_set_fscreate_secid(struct cachefiles_cache *cache)
+{
+	u32 tmp;
+	security_set_fscreate_secid(cache->cache_secid, &tmp);
+}
+#else
+#define cachefiles_get_security_ID(cache) (0)
+#define cachefiles_determine_cache_secid(cache, root) (0)
+#define cachefiles_set_fscreate_secid(cache) do {} while(0)
+#endif
+
+struct cachefiles_secctx {
+	uid_t	fsuid;			/* save for current->fsuid */
+	gid_t	fsgid;			/* save for current->fsgid */
+#ifdef CONFIG_SECURITY
+	u32	fscreate_secid;		/* save for current fscreate security ID */
+#endif
+};
+
+static inline void cachefiles_begin_secure_nofs(struct cachefiles_cache *cache,
+						struct cachefiles_secctx *ctx)
+{
+#ifdef CONFIG_SECURITY
+	u32 tmp;
+	security_act_as_secid(cache->access_secid, &tmp);
+	security_get_fscreate_secid(&ctx->fscreate_secid);
+#endif
+	ctx->fsuid = current->fsuid;
+	ctx->fsgid = current->fsgid;
+	current->fsuid = 0;
+	current->fsgid = 0;
+}
+
+static inline void cachefiles_begin_secure(struct cachefiles_cache *cache,
+					   struct cachefiles_secctx *ctx)
+{
+#ifdef CONFIG_SECURITY
+	u32 tmp;
+	security_act_as_secid(cache->access_secid, &tmp);
+	security_set_fscreate_secid(cache->cache_secid, &ctx->fscreate_secid);
+#endif
+	ctx->fsuid = current->fsuid;
+	ctx->fsgid = current->fsgid;
+	current->fsuid = 0;
+	current->fsgid = 0;
+}
+
+static inline void cachefiles_end_secure(struct cachefiles_cache *cache,
+					 const struct cachefiles_secctx *ctx)
+{
+#ifdef CONFIG_SECURITY
+	u32 tmp;
+#endif
+	current->fsuid = ctx->fsuid;
+	current->fsgid = ctx->fsgid;
+#ifdef CONFIG_SECURITY
+	security_set_fscreate_secid(ctx->fscreate_secid, &tmp);
+	security_act_as_self(&tmp);
+#endif
+}
+
+/*
+ * cf-xattr.c
+ */
+extern int cachefiles_check_object_type(struct cachefiles_object *object);
+extern int cachefiles_set_object_xattr(struct cachefiles_object *object,
+				       struct cachefiles_xattr *auxdata);
+extern int cachefiles_update_object_xattr(struct cachefiles_object *object,
+					  struct cachefiles_xattr *auxdata);
+extern int cachefiles_check_object_xattr(struct cachefiles_object *object,
+					 struct cachefiles_xattr *auxdata);
+extern int cachefiles_remove_object_xattr(struct cachefiles_cache *cache,
+					  struct dentry *dentry);
+
+
+/*
+ * error handling
+ */
+#define kerror(FMT,...) printk(KERN_ERR "CacheFiles: "FMT"\n" ,##__VA_ARGS__);
+
+#define cachefiles_io_error(___cache, FMT, ...)		\
+do {							\
+	kerror("I/O Error: " FMT ,##__VA_ARGS__);	\
+	fscache_io_error(&(___cache)->cache);		\
+	set_bit(CACHEFILES_DEAD, &(___cache)->flags);	\
+} while(0)
+
+#define cachefiles_io_error_obj(object, FMT, ...)			\
+do {									\
+	struct cachefiles_cache *___cache;				\
+									\
+	___cache = container_of((object)->fscache.cache,		\
+				struct cachefiles_cache, cache);	\
+	cachefiles_io_error(___cache, FMT ,##__VA_ARGS__);		\
+} while(0)
+
+
+/*
+ * debug tracing
+ */
+#define dbgprintk(FMT,...) \
+	printk("[%-6.6s] "FMT"\n",current->comm ,##__VA_ARGS__)
+
+/* make sure we maintain the format strings, even when debugging is disabled */
+static inline void _dbprintk(const char *fmt, ...)
+	__attribute__((format(printf,1,2)));
+static inline void _dbprintk(const char *fmt, ...)
+{
+}
+
+#define kenter(FMT,...)	dbgprintk("==> %s("FMT")",__FUNCTION__ ,##__VA_ARGS__)
+#define kleave(FMT,...)	dbgprintk("<== %s()"FMT"",__FUNCTION__ ,##__VA_ARGS__)
+#define kdebug(FMT,...)	dbgprintk(FMT ,##__VA_ARGS__)
+
+
+#if defined(__KDEBUG)
+#define _enter(FMT,...)	kenter(FMT,##__VA_ARGS__)
+#define _leave(FMT,...)	kleave(FMT,##__VA_ARGS__)
+#define _debug(FMT,...)	kdebug(FMT,##__VA_ARGS__)
+
+#elif defined(CONFIG_CACHEFILES_DEBUG)
+#define _enter(FMT,...)					\
+do {							\
+	if (cachefiles_debug & CACHEFILES_DEBUG_KENTER)	\
+		kenter(FMT,##__VA_ARGS__);		\
+} while (0)
+
+#define _leave(FMT,...)					\
+do {							\
+	if (cachefiles_debug & CACHEFILES_DEBUG_KLEAVE)	\
+		kleave(FMT,##__VA_ARGS__);		\
+} while (0)
+
+#define _debug(FMT,...)					\
+do {							\
+	if (cachefiles_debug & CACHEFILES_DEBUG_KDEBUG)	\
+		kdebug(FMT,##__VA_ARGS__);		\
+} while (0)
+
+#else
+#define _enter(FMT,...)	_dbprintk("==> %s("FMT")",__FUNCTION__ ,##__VA_ARGS__)
+#define _leave(FMT,...)	_dbprintk("<== %s()"FMT"",__FUNCTION__ ,##__VA_ARGS__)
+#define _debug(FMT,...)	_dbprintk(FMT ,##__VA_ARGS__)
+#endif
+
+#if 1 // defined(__KDEBUGALL)
+
+#define ASSERT(X)							\
+do {									\
+	if (unlikely(!(X))) {						\
+		printk(KERN_ERR "\n");					\
+		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
+		BUG();							\
+	}								\
+} while(0)
+
+#define ASSERTCMP(X, OP, Y)						\
+do {									\
+	if (unlikely(!((X) OP (Y)))) {					\
+		printk(KERN_ERR "\n");					\
+		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
+		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
+		       (unsigned long)(X), (unsigned long)(Y));		\
+		BUG();							\
+	}								\
+} while(0)
+
+#define ASSERTIF(C, X)							\
+do {									\
+	if (unlikely((C) && !(X))) {					\
+		printk(KERN_ERR "\n");					\
+		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
+		BUG();							\
+	}								\
+} while(0)
+
+#define ASSERTIFCMP(C, X, OP, Y)					\
+do {									\
+	if (unlikely((C) && !((X) OP (Y)))) {				\
+		printk(KERN_ERR "\n");					\
+		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
+		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
+		       (unsigned long)(X), (unsigned long)(Y));		\
+		BUG();							\
+	}								\
+} while(0)
+
+#else
+
+#define ASSERT(X)				\
+do {						\
+} while(0)
+
+#define ASSERTCMP(X, OP, Y)			\
+do {						\
+} while(0)
+
+#define ASSERTIF(C, X)				\
+do {						\
+} while(0)
+
+#define ASSERTIFCMP(C, X, OP, Y)		\
+do {						\
+} while(0)
+
+#endif
diff --git a/fs/cachefiles/cf-key.c b/fs/cachefiles/cf-key.c
new file mode 100644
index 0000000..6956eec
--- /dev/null
+++ b/fs/cachefiles/cf-key.c
@@ -0,0 +1,159 @@
+/* Key to pathname encoder
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/slab.h>
+#include "cf-internal.h"
+
+static const char cachefiles_charmap[64] =
+	"0123456789"			/* 0 - 9 */
+	"abcdefghijklmnopqrstuvwxyz"	/* 10 - 35 */
+	"ABCDEFGHIJKLMNOPQRSTUVWXYZ"	/* 36 - 61 */
+	"_-"				/* 62 - 63 */
+	;
+
+static const char cachefiles_filecharmap[256] = {
+	/* we skip space and tab and control chars */
+	[ 33 ... 46 ] = 1,		/* '!' -> '.' */
+	/* we skip '/' as it's significant to pathwalk */
+	[ 48 ... 127 ] = 1,		/* '0' -> '~' */
+};
+
+/*
+ * turn the raw key into something cooked
+ * - the raw key should include the length in the two bytes at the front
+ * - the key may be up to 514 bytes in length (including the length word)
+ *   - "base64" encode the strange keys, mapping 3 bytes of raw to four of
+ *     cooked
+ *   - need to cut the cooked key into 252 char lengths (189 raw bytes)
+ */
+char *cachefiles_cook_key(const u8 *raw, int keylen, uint8_t type)
+{
+	unsigned char csum, ch;
+	unsigned int acc;
+	char *key;
+	int loop, len, max, seg, mark, print;
+
+	_enter(",%d", keylen);
+
+	BUG_ON(keylen < 2 || keylen > 514);
+
+	csum = raw[0] + raw[1];
+	print = 1;
+	for (loop = 2; loop < keylen; loop++) {
+		ch = raw[loop];
+		csum += ch;
+		print &= cachefiles_filecharmap[ch];
+	}
+
+	if (print) {
+		/* if the path is usable ASCII, then we render it directly */
+		max = keylen - 2;
+		max += 2;	/* two base64'd length chars on the front */
+		max += 5;	/* @checksum/M */
+		max += 3 * 2;	/* maximum number of segment dividers (".../M")
+				 * is ((514 + 251) / 252) = 3
+				 */
+		max += 1;	/* NUL on end */
+	} else {
+		/* calculate the maximum length of the cooked key */
+		keylen = (keylen + 2) / 3;
+
+		max = keylen * 4;
+		max += 5;	/* @checksum/M */
+		max += 3 * 2;	/* maximum number of segment dividers (".../M")
+				 * is ((514 + 188) / 189) = 3
+				 */
+		max += 1;	/* NUL on end */
+	}
+
+	max += 1;	/* 2nd NUL on end */
+
+	_debug("max: %d", max);
+
+	key = kmalloc(max, GFP_KERNEL);
+	if (!key)
+		return NULL;
+
+	len = 0;
+
+	/* build the cooked key */
+	sprintf(key, "@%02x%c+", (unsigned) csum, 0);
+	len = 5;
+	mark = len - 1;
+
+	if (print) {
+		acc = *(uint16_t *) raw;
+		raw += 2;
+
+		key[len + 1] = cachefiles_charmap[acc & 63];
+		acc >>= 6;
+		key[len] = cachefiles_charmap[acc & 63];
+		len += 2;
+
+		seg = 250;
+		for (loop = keylen; loop > 0; loop--) {
+			if (seg <= 0) {
+				key[len++] = '\0';
+				mark = len;
+				key[len++] = '+';
+				seg = 252;
+			}
+
+			key[len++] = *raw++;
+			ASSERT(len < max);
+		}
+
+		switch (type) {
+		case FSCACHE_COOKIE_TYPE_INDEX:		type = 'I';	break;
+		case FSCACHE_COOKIE_TYPE_DATAFILE:	type = 'D';	break;
+		default:				type = 'S';	break;
+		}
+	} else {
+		seg = 252;
+		for (loop = keylen; loop > 0; loop--) {
+			if (seg <= 0) {
+				key[len++] = '\0';
+				mark = len;
+				key[len++] = '+';
+				seg = 252;
+			}
+
+			acc = *raw++;
+			acc |= *raw++ << 8;
+			acc |= *raw++ << 16;
+
+			_debug("acc: %06x", acc);
+
+			key[len++] = cachefiles_charmap[acc & 63];
+			acc >>= 6;
+			key[len++] = cachefiles_charmap[acc & 63];
+			acc >>= 6;
+			key[len++] = cachefiles_charmap[acc & 63];
+			acc >>= 6;
+			key[len++] = cachefiles_charmap[acc & 63];
+
+			ASSERT(len < max);
+		}
+
+		switch (type) {
+		case FSCACHE_COOKIE_TYPE_INDEX:		type = 'J';	break;
+		case FSCACHE_COOKIE_TYPE_DATAFILE:	type = 'E';	break;
+		default:				type = 'T';	break;
+		}
+	}
+
+	key[mark] = type;
+	key[len++] = 0;
+	key[len] = 0;
+
+	_leave(" = %p %d", key, len);
+	return key;
+}
diff --git a/fs/cachefiles/cf-main.c b/fs/cachefiles/cf-main.c
new file mode 100644
index 0000000..67bfdb3
--- /dev/null
+++ b/fs/cachefiles/cf-main.c
@@ -0,0 +1,109 @@
+/* Network filesystem caching backend to use cache files on a premounted
+ * filesystem
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/completion.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/namei.h>
+#include <linux/mount.h>
+#include <linux/statfs.h>
+#include <linux/sysctl.h>
+#include <linux/miscdevice.h>
+#include "cf-internal.h"
+
+unsigned cachefiles_debug;
+module_param_named(debug, cachefiles_debug, uint, S_IWUSR | S_IRUGO);
+MODULE_PARM_DESC(cachefiles_debug, "CacheFiles debugging mask");
+
+MODULE_DESCRIPTION("Mounted-filesystem based cache");
+MODULE_AUTHOR("Red Hat, Inc.");
+MODULE_LICENSE("GPL");
+
+struct kmem_cache *cachefiles_object_jar;
+
+static struct miscdevice cachefiles_dev = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "cachefiles",
+	.fops	= &cachefiles_daemon_fops,
+};
+
+static void cachefiles_object_init_once(void *_object,
+					struct kmem_cache *cachep,
+					unsigned long flags)
+{
+	struct cachefiles_object *object = _object;
+
+	memset(object, 0, sizeof(*object));
+	fscache_object_init(&object->fscache);
+	spin_lock_init(&object->work_lock);
+}
+
+/*
+ * initialise the fs caching module
+ */
+static int __init cachefiles_init(void)
+{
+	int ret;
+
+	ret = misc_register(&cachefiles_dev);
+	if (ret < 0)
+		goto error_dev;
+
+	/* create an object jar */
+	ret = -ENOMEM;
+	cachefiles_object_jar =
+		kmem_cache_create("cachefiles_object_jar",
+				  sizeof(struct cachefiles_object),
+				  0,
+				  SLAB_HWCACHE_ALIGN,
+				  cachefiles_object_init_once);
+	if (!cachefiles_object_jar) {
+		printk(KERN_NOTICE
+		       "CacheFiles: Failed to allocate an object jar\n");
+		goto error_object_jar;
+	}
+
+	ret = cachefiles_proc_init();
+	if (ret < 0)
+		goto error_proc;
+
+	printk(KERN_INFO "CacheFiles: Loaded\n");
+	return 0;
+
+error_proc:
+	kmem_cache_destroy(cachefiles_object_jar);
+error_object_jar:
+	misc_deregister(&cachefiles_dev);
+error_dev:
+	kerror("failed to register: %d", ret);
+	return ret;
+}
+
+fs_initcall(cachefiles_init);
+
+/*
+ * clean up on module removal
+ */
+static void __exit cachefiles_exit(void)
+{
+	printk(KERN_INFO "CacheFiles: Unloading\n");
+
+	cachefiles_proc_cleanup();
+	kmem_cache_destroy(cachefiles_object_jar);
+	misc_deregister(&cachefiles_dev);
+}
+
+module_exit(cachefiles_exit);
diff --git a/fs/cachefiles/cf-namei.c b/fs/cachefiles/cf-namei.c
new file mode 100644
index 0000000..809ddcb
--- /dev/null
+++ b/fs/cachefiles/cf-namei.c
@@ -0,0 +1,743 @@
+/* CacheFiles path walking and related routines
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/fsnotify.h>
+#include <linux/quotaops.h>
+#include <linux/xattr.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/security.h>
+#include "cf-internal.h"
+
+static int cachefiles_wait_bit(void *flags)
+{
+	schedule();
+	return 0;
+}
+
+/*
+ * record the fact that an object is now active
+ */
+static void cachefiles_mark_object_active(struct cachefiles_cache *cache,
+					  struct cachefiles_object *object)
+{
+	struct cachefiles_object *xobject;
+	struct rb_node **_p, *_parent = NULL;
+	struct dentry *dentry;
+
+	_enter(",%p", object);
+
+try_again:
+	write_lock(&cache->active_lock);
+
+	if (test_and_set_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags))
+		BUG();
+
+	dentry = object->dentry;
+	_p = &cache->active_nodes.rb_node;
+	while (*_p) {
+		_parent = *_p;
+		xobject = rb_entry(_parent,
+				   struct cachefiles_object, active_node);
+
+		if (xobject->dentry > dentry)
+			_p = &(*_p)->rb_left;
+		else if (xobject->dentry < dentry)
+			_p = &(*_p)->rb_right;
+		else
+			goto wait_for_old_object;
+	}
+
+	rb_link_node(&object->active_node, _parent, _p);
+	rb_insert_color(&object->active_node, &cache->active_nodes);
+
+	write_unlock(&cache->active_lock);
+	_leave("");
+	return;
+
+	/* an old object from a previous incarnation is hogging the slot - we
+	 * need to wait for it to be destroyed */
+wait_for_old_object:
+	_debug("old OBJ%x", xobject->fscache.debug_id);
+	ASSERTCMP(xobject->fscache.state, >=, FSCACHE_OBJECT_DYING);
+	atomic_inc(&xobject->usage);
+	//clear_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags);
+	write_unlock(&cache->active_lock);
+
+	_debug(">>> wait");
+	wait_on_bit(&xobject->flags, CACHEFILES_OBJECT_ACTIVE,
+		    cachefiles_wait_bit, TASK_UNINTERRUPTIBLE);
+	_debug("<<< waited");
+
+	cache->cache.ops->put_object(&xobject->fscache);
+	goto try_again;
+}
+
+/*
+ * delete an object representation from the cache
+ * - file backed objects are unlinked
+ * - directory backed objects are stuffed into the graveyard for userspace to
+ *   delete
+ * - unlocks the directory mutex
+ */
+static int cachefiles_bury_object(struct cachefiles_cache *cache,
+				  struct dentry *dir,
+				  struct dentry *rep)
+{
+	struct dentry *grave, *trap;
+	char nbuffer[8 + 8 + 1];
+	int ret;
+
+	_enter(",'%*.*s','%*.*s'",
+	       dir->d_name.len, dir->d_name.len, dir->d_name.name,
+	       rep->d_name.len, rep->d_name.len, rep->d_name.name);
+
+	/* non-directories can just be unlinked */
+	if (!S_ISDIR(rep->d_inode->i_mode)) {
+		_debug("unlink stale object");
+		ret = vfs_unlink(dir->d_inode, rep);
+
+		mutex_unlock(&dir->d_inode->i_mutex);
+
+		if (ret == -EIO)
+			cachefiles_io_error(cache, "Unlink failed");
+
+		_leave(" = %d", ret);
+		return ret;
+	}
+
+	/* directories have to be moved to the graveyard */
+	_debug("move stale object to graveyard");
+	mutex_unlock(&dir->d_inode->i_mutex);
+
+try_again:
+	/* first step is to make up a grave dentry in the graveyard */
+	sprintf(nbuffer, "%08x%08x",
+		(uint32_t) xtime.tv_sec,
+		(uint32_t) atomic_inc_return(&cache->gravecounter));
+
+	/* do the multiway lock magic */
+	trap = lock_rename(cache->graveyard, dir);
+
+	/* do some checks before getting the grave dentry */
+	if (rep->d_parent != dir) {
+		/* the entry was probably culled when we dropped the parent dir
+		 * lock */
+		unlock_rename(cache->graveyard, dir);
+		_leave(" = 0 [culled?]");
+		return 0;
+	}
+
+	if (!S_ISDIR(cache->graveyard->d_inode->i_mode)) {
+		unlock_rename(cache->graveyard, dir);
+		cachefiles_io_error(cache, "Graveyard no longer a directory");
+		return -EIO;
+	}
+
+	if (trap == rep) {
+		unlock_rename(cache->graveyard, dir);
+		cachefiles_io_error(cache, "May not make directory loop");
+		return -EIO;
+	}
+
+	if (d_mountpoint(rep)) {
+		unlock_rename(cache->graveyard, dir);
+		cachefiles_io_error(cache, "Mountpoint in cache");
+		return -EIO;
+	}
+
+	grave = lookup_one_len(nbuffer, cache->graveyard, strlen(nbuffer));
+	if (IS_ERR(grave)) {
+		unlock_rename(cache->graveyard, dir);
+
+		if (PTR_ERR(grave) == -ENOMEM) {
+			_leave(" = -ENOMEM");
+			return -ENOMEM;
+		}
+
+		cachefiles_io_error(cache, "Lookup error %ld",
+				    PTR_ERR(grave));
+		return -EIO;
+	}
+
+	if (grave->d_inode) {
+		unlock_rename(cache->graveyard, dir);
+		dput(grave);
+		grave = NULL;
+		cond_resched();
+		goto try_again;
+	}
+
+	if (d_mountpoint(grave)) {
+		unlock_rename(cache->graveyard, dir);
+		dput(grave);
+		cachefiles_io_error(cache, "Mountpoint in graveyard");
+		return -EIO;
+	}
+
+	/* target should not be an ancestor of source */
+	if (trap == grave) {
+		unlock_rename(cache->graveyard, dir);
+		dput(grave);
+		cachefiles_io_error(cache, "May not make directory loop");
+		return -EIO;
+	}
+
+	/* attempt the rename */
+	ret = vfs_rename(dir->d_inode, rep, cache->graveyard->d_inode, grave);
+	if (ret != 0 && ret != -ENOMEM)
+		cachefiles_io_error(cache, "Rename failed with error %d", ret);
+
+	unlock_rename(cache->graveyard, dir);
+	dput(grave);
+	_leave(" = 0");
+	return 0;
+}
+
+/*
+ * delete an object representation from the cache
+ */
+int cachefiles_delete_object(struct cachefiles_cache *cache,
+			     struct cachefiles_object *object)
+{
+	struct dentry *dir;
+	int ret;
+
+	_enter(",{%p}", object->dentry);
+
+	ASSERT(object->dentry);
+	ASSERT(object->dentry->d_inode);
+	ASSERT(object->dentry->d_parent);
+
+	dir = dget_parent(object->dentry);
+
+	mutex_lock(&dir->d_inode->i_mutex);
+	ret = cachefiles_bury_object(cache, dir, object->dentry);
+
+	dput(dir);
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * walk from the parent object to the child object through the backing
+ * filesystem, creating directories as we go
+ */
+int cachefiles_walk_to_object(struct cachefiles_object *parent,
+			      struct cachefiles_object *object,
+			      const char *key,
+			      struct cachefiles_xattr *auxdata)
+{
+	struct cachefiles_cache *cache;
+	struct dentry *dir, *next = NULL;
+	unsigned long start;
+	const char *name;
+	int ret, nlen;
+
+	_enter("{%p},,%s,", parent->dentry, key);
+
+	cache = container_of(parent->fscache.cache,
+			     struct cachefiles_cache, cache);
+
+	ASSERT(parent->dentry);
+	ASSERT(parent->dentry->d_inode);
+
+	if (!(S_ISDIR(parent->dentry->d_inode->i_mode))) {
+		// TODO: convert file to dir
+		_leave("looking up in none directory");
+		return -ENOBUFS;
+	}
+
+	dir = dget(parent->dentry);
+
+advance:
+	/* attempt to transit the first directory component */
+	name = key;
+	nlen = strlen(key);
+
+	/* key ends in a double NUL */
+	key = key + nlen + 1;
+	if (!*key)
+		key = NULL;
+
+lookup_again:
+	/* search the current directory for the element name */
+	_debug("lookup '%s'", name);
+
+	mutex_lock(&dir->d_inode->i_mutex);
+
+	start = jiffies;
+	next = lookup_one_len(name, dir, nlen);
+	cachefiles_hist(cachefiles_lookup_histogram, start);
+	if (IS_ERR(next))
+		goto lookup_error;
+
+	_debug("next -> %p %s", next, next->d_inode ? "positive" : "negative");
+
+	if (!key)
+		object->new = !next->d_inode;
+
+	/* if this element of the path doesn't exist, then the lookup phase
+	 * failed, and we can release any readers in the certain knowledge that
+	 * there's nothing for them to actually read */
+	if (!next->d_inode)
+		fscache_object_lookup_negative(&object->fscache);
+
+	/* we need to create the object if it's negative */
+	if (key || object->type == FSCACHE_COOKIE_TYPE_INDEX) {
+		/* index objects and intervening tree levels must be subdirs */
+		if (!next->d_inode) {
+			// TODO advance object state
+			ret = cachefiles_has_space(cache, 1, 0);
+			if (ret < 0)
+				goto create_error;
+
+			start = jiffies;
+			ret = vfs_mkdir(dir->d_inode, next, 0);
+			cachefiles_hist(cachefiles_mkdir_histogram, start);
+			if (ret < 0)
+				goto create_error;
+
+			ASSERT(next->d_inode);
+
+			_debug("mkdir -> %p{%p{ino=%lu}}",
+			       next, next->d_inode, next->d_inode->i_ino);
+
+		} else if (!S_ISDIR(next->d_inode->i_mode)) {
+			kerror("inode %lu is not a directory",
+			       next->d_inode->i_ino);
+			ret = -ENOBUFS;
+			goto error;
+		}
+
+	} else {
+		/* non-index objects start out life as files */
+		if (!next->d_inode) {
+			// TODO advance object state
+			ret = cachefiles_has_space(cache, 1, 0);
+			if (ret < 0)
+				goto create_error;
+
+			start = jiffies;
+			ret = vfs_create(dir->d_inode, next, S_IFREG, NULL);
+			cachefiles_hist(cachefiles_create_histogram, start);
+			if (ret < 0)
+				goto create_error;
+
+			ASSERT(next->d_inode);
+
+			_debug("create -> %p{%p{ino=%lu}}",
+			       next, next->d_inode, next->d_inode->i_ino);
+
+		} else if (!S_ISDIR(next->d_inode->i_mode) &&
+			   !S_ISREG(next->d_inode->i_mode)
+			   ) {
+			kerror("inode %lu is not a file or directory",
+			       next->d_inode->i_ino);
+			ret = -ENOBUFS;
+			goto error;
+		}
+	}
+
+	/* process the next component */
+	if (key) {
+		_debug("advance");
+		mutex_unlock(&dir->d_inode->i_mutex);
+		dput(dir);
+		dir = next;
+		next = NULL;
+		goto advance;
+	}
+
+	/* we've found the object we were looking for */
+	object->dentry = next;
+
+	/* if we've found that the terminal object exists, then we need to
+	 * check its attributes and delete it if it's out of date */
+	if (!object->new) {
+		_debug("validate '%*.*s'",
+		       next->d_name.len, next->d_name.len, next->d_name.name);
+
+		ret = cachefiles_check_object_xattr(object, auxdata);
+		if (ret == -ESTALE) {
+			/* delete the object (the deleter drops the directory
+			 * mutex) */
+			object->dentry = NULL;
+
+			ret = cachefiles_bury_object(cache, dir, next);
+			dput(next);
+			next = NULL;
+
+			if (ret < 0)
+				goto delete_error;
+
+			_debug("redo lookup");
+			goto lookup_again;
+		}
+	}
+
+	/* note that we're now using this object */
+	cachefiles_mark_object_active(cache, object);
+
+	mutex_unlock(&dir->d_inode->i_mutex);
+	dput(dir);
+	dir = NULL;
+
+	_debug("=== OBTAINED_OBJECT ===");
+
+	if (object->new) {
+		/* attach data to a newly constructed terminal object */
+		ret = cachefiles_set_object_xattr(object, auxdata);
+		if (ret < 0)
+			goto check_error;
+	} else {
+		/* always update the atime on an object we've just looked up
+		 * (this is used to keep track of culling, and atimes are only
+		 * updated by read, write and readdir but not lookup or
+		 * open) */
+		touch_atime(cache->mnt, next);
+	}
+
+	/* open a file interface onto a data file */
+	if (object->type != FSCACHE_COOKIE_TYPE_INDEX) {
+		if (S_ISREG(object->dentry->d_inode->i_mode)) {
+			const struct address_space_operations *aops;
+
+			ret = -EPERM;
+			aops = object->dentry->d_inode->i_mapping->a_ops;
+			if (!aops->bmap ||
+			    !aops->prepare_write ||
+			    !aops->commit_write ||
+			    !aops->write_one_page)
+				goto check_error;
+
+			object->backer = object->dentry;
+		} else {
+			BUG(); // TODO: open file in data-class subdir
+		}
+	}
+
+	object->new = 0;
+	fscache_obtained_object(&object->fscache);
+
+	_leave(" = 0 [%lu]", object->dentry->d_inode->i_ino);
+	return 0;
+
+create_error:
+	_debug("create error %d", ret);
+	if (ret == -EIO)
+		cachefiles_io_error(cache, "Create/mkdir failed");
+	goto error;
+
+check_error:
+	_debug("check error %d", ret);
+	write_lock(&cache->active_lock);
+	rb_erase(&object->active_node, &cache->active_nodes);
+	write_unlock(&cache->active_lock);
+
+	dput(object->dentry);
+	object->dentry = NULL;
+	goto error_out;
+
+delete_error:
+	_debug("delete error %d", ret);
+	goto error_out2;
+
+lookup_error:
+	_debug("lookup error %ld", PTR_ERR(next));
+	ret = PTR_ERR(next);
+	if (ret == -EIO)
+		cachefiles_io_error(cache, "Lookup failed");
+	next = NULL;
+error:
+	mutex_unlock(&dir->d_inode->i_mutex);
+	dput(next);
+error_out2:
+	dput(dir);
+error_out:
+	if (ret == -ENOSPC)
+		ret = -ENOBUFS;
+
+	_leave(" = error %d", -ret);
+	return ret;
+}
+
+/*
+ * get a subdirectory
+ */
+struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
+					struct dentry *dir,
+					const char *dirname)
+{
+	struct dentry *subdir;
+	unsigned long start;
+	int ret;
+
+	_enter(",,%s", dirname);
+
+	/* search the current directory for the element name */
+	mutex_lock(&dir->d_inode->i_mutex);
+
+	start = jiffies;
+	subdir = lookup_one_len(dirname, dir, strlen(dirname));
+	cachefiles_hist(cachefiles_lookup_histogram, start);
+	if (IS_ERR(subdir)) {
+		if (PTR_ERR(subdir) == -ENOMEM)
+			goto nomem_d_alloc;
+		goto lookup_error;
+	}
+
+	_debug("subdir -> %p %s",
+	       subdir, subdir->d_inode ? "positive" : "negative");
+
+	/* we need to create the subdir if it doesn't exist yet */
+	if (!subdir->d_inode) {
+		ret = cachefiles_has_space(cache, 1, 0);
+		if (ret < 0)
+			goto mkdir_error;
+
+		_debug("attempt mkdir");
+
+		ret = vfs_mkdir(dir->d_inode, subdir, 0700);
+		if (ret < 0)
+			goto mkdir_error;
+
+		ASSERT(subdir->d_inode);
+
+		_debug("mkdir -> %p{%p{ino=%lu}}",
+		       subdir,
+		       subdir->d_inode,
+		       subdir->d_inode->i_ino);
+	}
+
+	mutex_unlock(&dir->d_inode->i_mutex);
+
+	/* we need to make sure the subdir is a directory */
+	ASSERT(subdir->d_inode);
+
+	if (!S_ISDIR(subdir->d_inode->i_mode)) {
+		kerror("%s is not a directory", dirname);
+		ret = -EIO;
+		goto check_error;
+	}
+
+	ret = -EPERM;
+	if (!subdir->d_inode->i_op ||
+	    !subdir->d_inode->i_op->setxattr ||
+	    !subdir->d_inode->i_op->getxattr ||
+	    !subdir->d_inode->i_op->lookup ||
+	    !subdir->d_inode->i_op->mkdir ||
+	    !subdir->d_inode->i_op->create ||
+	    !subdir->d_inode->i_op->rename ||
+	    !subdir->d_inode->i_op->rmdir ||
+	    !subdir->d_inode->i_op->unlink)
+		goto check_error;
+
+	_leave(" = [%lu]", subdir->d_inode->i_ino);
+	return subdir;
+
+check_error:
+	dput(subdir);
+	_leave(" = %d [check]", ret);
+	return ERR_PTR(ret);
+
+mkdir_error:
+	mutex_unlock(&dir->d_inode->i_mutex);
+	dput(subdir);
+	kerror("mkdir %s failed with error %d", dirname, ret);
+	return ERR_PTR(ret);
+
+lookup_error:
+	mutex_unlock(&dir->d_inode->i_mutex);
+	ret = PTR_ERR(subdir);
+	kerror("Lookup %s failed with error %d", dirname, ret);
+	return ERR_PTR(ret);
+
+nomem_d_alloc:
+	mutex_unlock(&dir->d_inode->i_mutex);
+	_leave(" = -ENOMEM");
+	return ERR_PTR(-ENOMEM);
+}
+
+/*
+ * find out if an object is in use or not
+ * - if finds object and it's not in use:
+ *   - returns a pointer to the object and a reference on it
+ *   - returns with the directory locked
+ */
+static struct dentry *cachefiles_check_active(struct cachefiles_cache *cache,
+					      struct dentry *dir,
+					      char *filename)
+{
+	struct cachefiles_object *object;
+	struct rb_node *_n;
+	struct dentry *victim;
+	unsigned long start;
+	int ret;
+
+	_enter(",%*.*s/,%s",
+	       dir->d_name.len, dir->d_name.len, dir->d_name.name, filename);
+
+	/* look up the victim */
+	mutex_lock_nested(&dir->d_inode->i_mutex, 1);
+
+	start = jiffies;
+	victim = lookup_one_len(filename, dir, strlen(filename));
+	cachefiles_hist(cachefiles_lookup_histogram, start);
+	if (IS_ERR(victim))
+		goto lookup_error;
+
+	_debug("victim -> %p %s",
+	       victim, victim->d_inode ? "positive" : "negative");
+
+	/* if the object is no longer there then we probably retired the object
+	 * at the netfs's request whilst the cull was in progress
+	 */
+	if (!victim->d_inode) {
+		mutex_unlock(&dir->d_inode->i_mutex);
+		dput(victim);
+		_leave(" = -ENOENT [absent]");
+		return ERR_PTR(-ENOENT);
+	}
+
+	/* check to see if we're using this object */
+	read_lock(&cache->active_lock);
+
+	_n = cache->active_nodes.rb_node;
+
+	while (_n) {
+		object = rb_entry(_n, struct cachefiles_object, active_node);
+
+		if (object->dentry > victim)
+			_n = _n->rb_left;
+		else if (object->dentry < victim)
+			_n = _n->rb_right;
+		else
+			goto object_in_use;
+	}
+
+	read_unlock(&cache->active_lock);
+
+	_leave(" = %p", victim);
+	return victim;
+
+object_in_use:
+	read_unlock(&cache->active_lock);
+	mutex_unlock(&dir->d_inode->i_mutex);
+	dput(victim);
+	_leave(" = -EBUSY [in use]");
+	return ERR_PTR(-EBUSY);
+
+lookup_error:
+	mutex_unlock(&dir->d_inode->i_mutex);
+	ret = PTR_ERR(victim);
+	if (ret == -ENOENT) {
+		/* file or dir now absent - probably retired by netfs */
+		_leave(" = -ESTALE [absent]");
+		return ERR_PTR(-ESTALE);
+	}
+
+	if (ret == -EIO) {
+		cachefiles_io_error(cache, "Lookup failed");
+	} else if (ret != -ENOMEM) {
+		kerror("Internal error: %d", ret);
+		ret = -EIO;
+	}
+
+	_leave(" = %d", ret);
+	return ERR_PTR(ret);
+}
+
+/*
+ * cull an object if it's not in use
+ * - called only by cache manager daemon
+ */
+int cachefiles_cull(struct cachefiles_cache *cache, struct dentry *dir,
+		    char *filename)
+{
+	struct dentry *victim;
+	int ret;
+
+	_enter(",%*.*s/,%s",
+	       dir->d_name.len, dir->d_name.len, dir->d_name.name, filename);
+
+	victim = cachefiles_check_active(cache, dir, filename);
+	if (IS_ERR(victim))
+		return PTR_ERR(victim);
+
+	_debug("victim -> %p %s",
+	       victim, victim->d_inode ? "positive" : "negative");
+
+	/* okay... the victim is not being used so we can cull it
+	 * - start by marking it as stale
+	 */
+	_debug("victim is cullable");
+
+	ret = cachefiles_remove_object_xattr(cache, victim);
+	if (ret < 0)
+		goto error_unlock;
+
+	/*  actually remove the victim (drops the dir mutex) */
+	_debug("bury");
+
+	ret = cachefiles_bury_object(cache, dir, victim);
+	if (ret < 0)
+		goto error;
+
+	dput(victim);
+	_leave(" = 0");
+	return 0;
+
+error_unlock:
+	mutex_unlock(&dir->d_inode->i_mutex);
+error:
+	dput(victim);
+	if (ret == -ENOENT) {
+		/* file or dir now absent - probably retired by netfs */
+		_leave(" = -ESTALE [absent]");
+		return -ESTALE;
+	}
+
+	if (ret != -ENOMEM) {
+		kerror("Internal error: %d", ret);
+		ret = -EIO;
+	}
+
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * find out if an object is in use or not
+ * - called only by cache manager daemon
+ * - returns -EBUSY or 0 to indicate whether an object is in use or not
+ */
+int cachefiles_check_in_use(struct cachefiles_cache *cache, struct dentry *dir,
+			    char *filename)
+{
+	struct dentry *victim;
+
+	_enter(",%*.*s/,%s",
+	       dir->d_name.len, dir->d_name.len, dir->d_name.name, filename);
+
+	victim = cachefiles_check_active(cache, dir, filename);
+	if (IS_ERR(victim))
+		return PTR_ERR(victim);
+
+	mutex_unlock(&dir->d_inode->i_mutex);
+	dput(victim);
+	_leave(" = 0");
+	return 0;
+}
diff --git a/fs/cachefiles/cf-proc.c b/fs/cachefiles/cf-proc.c
new file mode 100644
index 0000000..c0d5444
--- /dev/null
+++ b/fs/cachefiles/cf-proc.c
@@ -0,0 +1,166 @@
+/* CacheFiles statistics
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include "cf-internal.h"
+
+struct cachefiles_proc {
+	unsigned			nlines;
+	const struct seq_operations	*ops;
+};
+
+atomic_t cachefiles_lookup_histogram[HZ];
+atomic_t cachefiles_mkdir_histogram[HZ];
+atomic_t cachefiles_create_histogram[HZ];
+
+static struct proc_dir_entry *proc_cachefiles;
+
+static int cachefiles_proc_open(struct inode *inode, struct file *file);
+static void *cachefiles_proc_start(struct seq_file *m, loff_t *pos);
+static void cachefiles_proc_stop(struct seq_file *m, void *v);
+static void *cachefiles_proc_next(struct seq_file *m, void *v, loff_t *pos);
+static int cachefiles_histogram_show(struct seq_file *m, void *v);
+
+static const struct file_operations cachefiles_proc_fops = {
+	.open		= cachefiles_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static const struct seq_operations cachefiles_histogram_ops = {
+	.start		= cachefiles_proc_start,
+	.stop		= cachefiles_proc_stop,
+	.next		= cachefiles_proc_next,
+	.show		= cachefiles_histogram_show,
+};
+
+static const struct cachefiles_proc cachefiles_histogram = {
+	.nlines		= HZ + 1,
+	.ops		= &cachefiles_histogram_ops,
+};
+
+/*
+ * initialise the /proc/fs/fscache/cachefiles/ directory
+ */
+int __init cachefiles_proc_init(void)
+{
+	struct proc_dir_entry *p;
+
+	_enter("");
+
+	proc_cachefiles = proc_mkdir("cachefiles", proc_fscache);
+	if (!proc_cachefiles)
+		goto error_dir;
+	proc_cachefiles->owner = THIS_MODULE;
+
+	p = create_proc_entry("histogram", 0, proc_cachefiles);
+	if (!p)
+		goto error_histogram;
+	p->proc_fops = &cachefiles_proc_fops;
+	p->owner = THIS_MODULE;
+	p->data = (void *) &cachefiles_histogram;
+
+	_leave(" = 0");
+	return 0;
+
+error_histogram:
+	remove_proc_entry("fs/cachefiles", NULL);
+error_dir:
+	_leave(" = -ENOMEM");
+	return -ENOMEM;
+}
+
+/*
+ * clean up the /proc/fs/fscache/cachefiles/ directory
+ */
+void cachefiles_proc_cleanup(void)
+{
+	remove_proc_entry("histogram", proc_cachefiles);
+	remove_proc_entry("cachefiles", proc_fscache);
+}
+
+/*
+ * open "/proc/fs/fscache/cachefiles/XXX" which provide statistics summaries
+ */
+static int cachefiles_proc_open(struct inode *inode, struct file *file)
+{
+	const struct cachefiles_proc *proc = PDE(inode)->data;
+	struct seq_file *m;
+	int ret;
+
+	ret = seq_open(file, proc->ops);
+	if (ret == 0) {
+		m = file->private_data;
+		m->private = (void *) proc;
+	}
+	return ret;
+}
+
+/*
+ * set up the iterator to start reading from the first line
+ */
+static void *cachefiles_proc_start(struct seq_file *m, loff_t *_pos)
+{
+	if (*_pos == 0)
+		*_pos = 1;
+	return (void *)(unsigned long) *_pos;
+}
+
+/*
+ * move to the next line
+ */
+static void *cachefiles_proc_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	const struct cachefiles_proc *proc = m->private;
+
+	(*pos)++;
+	return *pos > proc->nlines ? NULL : (void *)(unsigned long) *pos;
+}
+
+/*
+ * clean up after reading
+ */
+static void cachefiles_proc_stop(struct seq_file *m, void *v)
+{
+}
+
+/*
+ * display the time-taken histogram
+ */
+static int cachefiles_histogram_show(struct seq_file *m, void *v)
+{
+	unsigned long index;
+	unsigned x, y, z, t;
+
+	switch ((unsigned long) v) {
+	case 1:
+		seq_puts(m, "JIFS  SECS  LOOKUPS   MKDIRS    CREATES\n");
+		return 0;
+	case 2:
+		seq_puts(m, "===== ===== ========= ========= =========\n");
+		return 0;
+	default:
+		index = (unsigned long) v - 3;
+		x = atomic_read(&cachefiles_lookup_histogram[index]);
+		y = atomic_read(&cachefiles_mkdir_histogram[index]);
+		z = atomic_read(&cachefiles_create_histogram[index]);
+		if (x == 0 && y == 0 && z == 0)
+			return 0;
+
+		t = (index * 1000) / HZ;
+
+		seq_printf(m, "%4lu  0.%03u %9u %9u %9u\n", index, t, x, y, z);
+		return 0;
+	}
+}
diff --git a/fs/cachefiles/cf-rdwr.c b/fs/cachefiles/cf-rdwr.c
new file mode 100644
index 0000000..5233477
--- /dev/null
+++ b/fs/cachefiles/cf-rdwr.c
@@ -0,0 +1,849 @@
+/* Storage object read/write
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include "cf-internal.h"
+
+/*
+ * detect wake up events generated by the unlocking of pages in which we're
+ * interested
+ * - we use this to detect read completion of backing pages
+ * - the caller holds the waitqueue lock
+ */
+static int cachefiles_read_waiter(wait_queue_t *wait, unsigned mode,
+				  int sync, void *_key)
+{
+	struct cachefiles_one_read *monitor =
+		container_of(wait, struct cachefiles_one_read, monitor);
+	struct cachefiles_object *object;
+	struct wait_bit_key *key = _key;
+	struct page *page = wait->private;
+
+	ASSERT(key);
+
+	_enter("{%lu},%u,%d,{%p,%u}",
+	       monitor->netfs_page->index, mode, sync,
+	       key->flags, key->bit_nr);
+
+	if (key->flags != &page->flags ||
+	    key->bit_nr != PG_locked)
+		return 0;
+
+	_debug("--- monitor %p %lx ---", page, page->flags);
+
+	if (!PageUptodate(page) && !PageError(page))
+		dump_stack();
+
+	/* remove from the waitqueue */
+	list_del(&wait->task_list);
+
+	/* move onto the action list and queue for FS-Cache thread pool */
+	ASSERT(monitor->op);
+
+	object = container_of(monitor->op->op.object,
+			      struct cachefiles_object, fscache);
+
+	spin_lock(&object->work_lock);
+	list_add(&monitor->op_link, &monitor->op->to_do);
+	spin_unlock(&object->work_lock);
+
+	fscache_enqueue_retrieval(monitor->op);
+	return 0;
+}
+
+/*
+ * copy data from backing pages to netfs pages to complete a read operation
+ * - driven by FS-Cache's thread pool
+ */
+static void cachefiles_read_copier(struct fscache_operation *_op)
+{
+	struct cachefiles_one_read *monitor;
+	struct cachefiles_object *object;
+	struct fscache_retrieval *op;
+	struct pagevec pagevec;
+	int error, max;
+
+	op = container_of(_op, struct fscache_retrieval, op);
+	object = container_of(op->op.object,
+			      struct cachefiles_object, fscache);
+
+	_enter("{ino=%lu}", object->backer->d_inode->i_ino);
+
+	pagevec_init(&pagevec, 0);
+
+	max = 8;
+	spin_lock_irq(&object->work_lock);
+
+	while (!list_empty(&op->to_do)) {
+		monitor = list_entry(op->to_do.next,
+				     struct cachefiles_one_read, op_link);
+		list_del(&monitor->op_link);
+
+		spin_unlock_irq(&object->work_lock);
+
+		_debug("- copy {%lu}", monitor->back_page->index);
+
+		error = -EIO;
+		if (PageUptodate(monitor->back_page)) {
+			copy_highpage(monitor->netfs_page, monitor->back_page);
+
+			pagevec_add(&pagevec, monitor->netfs_page);
+			fscache_mark_pages_cached(monitor->op, &pagevec);
+			error = 0;
+		}
+
+		if (error)
+			cachefiles_io_error_obj(
+				object,
+				"Readpage failed on backing file %lx",
+				(unsigned long) monitor->back_page->flags);
+
+		page_cache_release(monitor->back_page);
+
+		fscache_end_io(op, monitor->netfs_page, error);
+		page_cache_release(monitor->netfs_page);
+		fscache_put_retrieval(op);
+		kfree(monitor);
+
+		/* let the thread pool have some air occasionally */
+		max--;
+		if (max < 0 || need_resched()) {
+			if (!list_empty(&op->to_do))
+				fscache_enqueue_retrieval(op);
+			_leave(" [maxed out]");
+			return;
+		}
+
+		spin_lock_irq(&object->work_lock);
+	}
+
+	spin_unlock_irq(&object->work_lock);
+	_leave("");
+}
+
+/*
+ * read the corresponding page to the given set from the backing file
+ * - an uncertain page is simply discarded, to be tried again another time
+ */
+static int cachefiles_read_backing_file_one(struct cachefiles_object *object,
+					    struct fscache_retrieval *op,
+					    struct page *netpage,
+					    struct pagevec *pagevec)
+{
+	struct cachefiles_one_read *monitor;
+	struct address_space *bmapping;
+	struct page *newpage, *backpage;
+	int ret;
+
+	_enter("");
+
+	pagevec_reinit(pagevec);
+
+	_debug("read back %p{%lu,%d}",
+	       netpage, netpage->index, page_count(netpage));
+
+	monitor = kzalloc(sizeof(*monitor), GFP_KERNEL);
+	if (!monitor)
+		goto nomem;
+
+	monitor->netfs_page = netpage;
+	monitor->op = fscache_get_retrieval(op);
+
+	init_waitqueue_func_entry(&monitor->monitor, cachefiles_read_waiter);
+
+	/* attempt to get hold of the backing page */
+	bmapping = object->backer->d_inode->i_mapping;
+	newpage = NULL;
+
+	for (;;) {
+		backpage = find_get_page(bmapping, netpage->index);
+		if (backpage)
+			goto backing_page_already_present;
+
+		if (!newpage) {
+			newpage = page_cache_alloc_cold(bmapping);
+			if (!newpage)
+				goto nomem_monitor;
+		}
+
+		ret = add_to_page_cache(newpage, bmapping,
+					netpage->index, GFP_KERNEL);
+		if (ret == 0)
+			goto installed_new_backing_page;
+		if (ret != -EEXIST)
+			goto nomem_page;
+	}
+
+	/* we've installed a new backing page, so now we need to add it
+	 * to the LRU list and start it reading */
+installed_new_backing_page:
+	_debug("- new %p", newpage);
+
+	backpage = newpage;
+	newpage = NULL;
+
+	page_cache_get(backpage);
+	pagevec_add(pagevec, backpage);
+	__pagevec_lru_add(pagevec);
+
+read_backing_page:
+	ret = bmapping->a_ops->readpage(NULL, backpage);
+	if (ret < 0)
+		goto read_error;
+
+	/* set the monitor to transfer the data across */
+monitor_backing_page:
+	_debug("- monitor add");
+
+	/* install the monitor */
+	page_cache_get(monitor->netfs_page);
+	page_cache_get(backpage);
+	monitor->back_page = backpage;
+	monitor->monitor.private = backpage;
+	add_page_wait_queue(backpage, &monitor->monitor);
+	monitor = NULL;
+
+	/* but the page may have been read before the monitor was installed, so
+	 * the monitor may miss the event - so we have to ensure that we do get
+	 * one in such a case */
+	if (!TestSetPageLocked(backpage)) {
+		_debug("jumpstart %p {%lx}", backpage, backpage->flags);
+		unlock_page(backpage);
+	}
+	goto success;
+
+	/* if the backing page is already present, it can be in one of
+	 * three states: read in progress, read failed or read okay */
+backing_page_already_present:
+	_debug("- present");
+
+	if (newpage) {
+		page_cache_release(newpage);
+		newpage = NULL;
+	}
+
+	if (PageError(backpage))
+		goto io_error;
+
+	if (PageUptodate(backpage))
+		goto backing_page_already_uptodate;
+
+	if (TestSetPageLocked(backpage))
+		goto monitor_backing_page;
+	_debug("read %p {%lx}", backpage, backpage->flags);
+	goto read_backing_page;
+
+	/* the backing page is already up to date, attach the netfs
+	 * page to the pagecache and LRU and copy the data across */
+backing_page_already_uptodate:
+	_debug("- uptodate");
+
+	pagevec_add(pagevec, netpage);
+	fscache_mark_pages_cached(op, pagevec);
+
+	copy_highpage(netpage, backpage);
+	fscache_end_io(op, netpage, 0);
+
+success:
+	_debug("success");
+	ret = 0;
+
+out:
+	if (backpage)
+		page_cache_release(backpage);
+	if (monitor) {
+		fscache_put_retrieval(monitor->op);
+		kfree(monitor);
+	}
+	_leave(" = %d", ret);
+	return ret;
+
+read_error:
+	_debug("read error %d", ret);
+	if (ret == -ENOMEM)
+		goto out;
+io_error:
+	cachefiles_io_error_obj(object, "Page read error on backing file");
+	ret = -ENOBUFS;
+	goto out;
+
+nomem_page:
+	page_cache_release(newpage);
+nomem_monitor:
+	fscache_put_retrieval(monitor->op);
+	kfree(monitor);
+nomem:
+	_leave(" = -ENOMEM");
+	return -ENOMEM;
+}
+
+/*
+ * read a page from the cache or allocate a block in which to store it
+ * - cache withdrawal is prevented by the caller
+ * - returns -EINTR if interrupted
+ * - returns -ENOMEM if ran out of memory
+ * - returns -ENOBUFS if no buffers can be made available
+ * - returns -ENOBUFS if page is beyond EOF
+ * - if the page is backed by a block in the cache:
+ *   - a read will be started which will call the callback on completion
+ *   - 0 will be returned
+ * - else if the page is unbacked:
+ *   - the metadata will be retained
+ *   - -ENODATA will be returned
+ */
+int cachefiles_read_or_alloc_page(struct fscache_retrieval *op,
+				  struct page *page,
+				  gfp_t gfp)
+{
+	struct cachefiles_object *object;
+	struct cachefiles_cache *cache;
+	struct pagevec pagevec;
+	struct inode *inode;
+	sector_t block0, block;
+	unsigned shift;
+	int ret;
+
+	object = container_of(op->op.object,
+			      struct cachefiles_object, fscache);
+	cache = container_of(object->fscache.cache,
+			     struct cachefiles_cache, cache);
+
+	_enter("{%p},{%lx},,,", object, page->index);
+
+	if (!object->backer)
+		return -ENOBUFS;
+
+	inode = object->backer->d_inode;
+	ASSERT(S_ISREG(inode->i_mode));
+	ASSERT(inode->i_mapping->a_ops->bmap);
+	ASSERT(inode->i_mapping->a_ops->readpages);
+
+	/* calculate the shift required to use bmap */
+	if (inode->i_sb->s_blocksize > PAGE_SIZE)
+		return -ENOBUFS;
+
+	shift = PAGE_SHIFT - inode->i_sb->s_blocksize_bits;
+
+	op->op.processor = cachefiles_read_copier;
+
+	pagevec_init(&pagevec, 0);
+
+	/* we assume the absence or presence of the first block is a good
+	 * enough indication for the page as a whole
+	 * - TODO: don't use bmap() for this as it is _not_ actually good
+	 *   enough for this as it doesn't indicate errors, but it's all we've
+	 *   got for the moment
+	 */
+	block0 = page->index;
+	block0 <<= shift;
+
+	block = inode->i_mapping->a_ops->bmap(inode->i_mapping, block0);
+	_debug("%llx -> %llx",
+	       (unsigned long long) block0,
+	       (unsigned long long) block);
+
+	if (block) {
+		/* submit the apparently valid page to the backing fs to be
+		 * read from disk */
+		ret = cachefiles_read_backing_file_one(object, op, page,
+						       &pagevec);
+	} else if (cachefiles_has_space(cache, 0, 1) == 0) {
+		/* there's space in the cache we can use */
+		pagevec_add(&pagevec, page);
+		fscache_mark_pages_cached(op, &pagevec);
+		ret = -ENODATA;
+	} else {
+		ret = -ENOBUFS;
+	}
+
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * read the corresponding pages to the given set from the backing file
+ * - any uncertain pages are simply discarded, to be tried again another time
+ */
+static int cachefiles_read_backing_file(struct cachefiles_object *object,
+					struct fscache_retrieval *op,
+					struct list_head *list,
+					struct pagevec *mark_pvec)
+{
+	struct cachefiles_one_read *monitor = NULL;
+	struct address_space *bmapping = object->backer->d_inode->i_mapping;
+	struct pagevec lru_pvec;
+	struct page *newpage = NULL, *netpage, *_n, *backpage = NULL;
+	int ret = 0;
+
+	_enter("");
+
+	pagevec_init(&lru_pvec, 0);
+
+	list_for_each_entry_safe(netpage, _n, list, lru) {
+		list_del(&netpage->lru);
+
+		_debug("read back %p{%lu,%d}",
+		       netpage, netpage->index, page_count(netpage));
+
+		if (!monitor) {
+			monitor = kzalloc(sizeof(*monitor), GFP_KERNEL);
+			if (!monitor)
+				goto nomem;
+
+			monitor->op = fscache_get_retrieval(op);
+			init_waitqueue_func_entry(&monitor->monitor,
+						  cachefiles_read_waiter);
+		}
+
+		for (;;) {
+			backpage = find_get_page(bmapping, netpage->index);
+			if (backpage)
+				goto backing_page_already_present;
+
+			if (!newpage) {
+				newpage = page_cache_alloc_cold(bmapping);
+				if (!newpage)
+					goto nomem;
+			}
+
+			ret = add_to_page_cache(newpage, bmapping,
+						netpage->index, GFP_KERNEL);
+			if (ret == 0)
+				goto installed_new_backing_page;
+			if (ret != -EEXIST)
+				goto nomem;
+		}
+
+		/* we've installed a new backing page, so now we need to add it
+		 * to the LRU list and start it reading */
+	installed_new_backing_page:
+		_debug("- new %p", newpage);
+
+		backpage = newpage;
+		newpage = NULL;
+
+		page_cache_get(backpage);
+		if (!pagevec_add(&lru_pvec, backpage))
+			__pagevec_lru_add(&lru_pvec);
+
+	reread_backing_page:
+		ret = bmapping->a_ops->readpage(NULL, backpage);
+		if (ret < 0)
+			goto read_error;
+
+		/* add the netfs page to the pagecache and LRU, and set the
+		 * monitor to transfer the data across */
+	monitor_backing_page:
+		_debug("- monitor add");
+
+		ret = add_to_page_cache(netpage, op->mapping, netpage->index,
+					GFP_KERNEL);
+		if (ret < 0) {
+			if (ret == -EEXIST) {
+				page_cache_release(netpage);
+				continue;
+			}
+			goto nomem;
+		}
+
+		page_cache_get(netpage);
+		if (!pagevec_add(&lru_pvec, netpage))
+			__pagevec_lru_add(&lru_pvec);
+
+		/* install a monitor */
+		page_cache_get(netpage);
+		monitor->netfs_page = netpage;
+
+		page_cache_get(backpage);
+		monitor->back_page = backpage;
+		monitor->monitor.private = backpage;
+		add_page_wait_queue(backpage, &monitor->monitor);
+		monitor = NULL;
+
+		/* but the page may have been read before the monitor was
+		 * installed, so the monitor may miss the event - so we have to
+		 * ensure that we do get one in such a case */
+		if (!TestSetPageLocked(backpage)) {
+			_debug("2unlock %p {%lx}", backpage, backpage->flags);
+			unlock_page(backpage);
+		}
+
+		page_cache_release(backpage);
+		backpage = NULL;
+
+		page_cache_release(netpage);
+		netpage = NULL;
+		continue;
+
+		/* if the backing page is already present, it can be in one of
+		 * three states: read in progress, read failed or read okay */
+	backing_page_already_present:
+		_debug("- present %p", backpage);
+
+		if (PageError(backpage))
+			goto io_error;
+
+		if (PageUptodate(backpage))
+			goto backing_page_already_uptodate;
+
+		_debug("- not ready %p{%lx}", backpage, backpage->flags);
+
+		if (TestSetPageLocked(backpage))
+			goto monitor_backing_page;
+
+		if (PageError(backpage)) {
+			_debug("error %lx", backpage->flags);
+			unlock_page(backpage);
+			goto io_error;
+		}
+
+		if (PageUptodate(backpage))
+			goto backing_page_already_uptodate_unlock;
+
+		/* we've locked a page that's neither up to date nor erroneous,
+		 * so we need to attempt to read it again */
+		goto reread_backing_page;
+
+		/* the backing page is already up to date, attach the netfs
+		 * page to the pagecache and LRU and copy the data across */
+	backing_page_already_uptodate_unlock:
+		_debug("uptodate %lx", backpage->flags);
+		unlock_page(backpage);
+	backing_page_already_uptodate:
+		_debug("- uptodate");
+
+		ret = add_to_page_cache(netpage, op->mapping, netpage->index,
+					GFP_KERNEL);
+		if (ret < 0) {
+			if (ret == -EEXIST) {
+				page_cache_release(netpage);
+				continue;
+			}
+			goto nomem;
+		}
+
+		copy_highpage(netpage, backpage);
+
+		page_cache_release(backpage);
+		backpage = NULL;
+
+		if (!pagevec_add(mark_pvec, netpage))
+			fscache_mark_pages_cached(op, mark_pvec);
+
+		page_cache_get(netpage);
+		if (!pagevec_add(&lru_pvec, netpage))
+			__pagevec_lru_add(&lru_pvec);
+
+		fscache_end_io(op, netpage, 0);
+		page_cache_release(netpage);
+		netpage = NULL;
+		continue;
+	}
+
+	netpage = NULL;
+
+	_debug("out");
+
+out:
+	/* tidy up */
+	pagevec_lru_add(&lru_pvec);
+
+	if (newpage)
+		page_cache_release(newpage);
+	if (netpage)
+		page_cache_release(netpage);
+	if (backpage)
+		page_cache_release(backpage);
+	if (monitor) {
+		fscache_put_retrieval(op);
+		kfree(monitor);
+	}
+
+	list_for_each_entry_safe(netpage, _n, list, lru) {
+		list_del(&netpage->lru);
+		page_cache_release(netpage);
+	}
+
+	_leave(" = %d", ret);
+	return ret;
+
+nomem:
+	_debug("nomem");
+	ret = -ENOMEM;
+	goto out;
+
+read_error:
+	_debug("read error %d", ret);
+	if (ret == -ENOMEM)
+		goto out;
+io_error:
+	cachefiles_io_error_obj(object, "Page read error on backing file");
+	ret = -ENOBUFS;
+	goto out;
+}
+
+/*
+ * read a list of pages from the cache or allocate blocks in which to store
+ * them
+ */
+int cachefiles_read_or_alloc_pages(struct fscache_retrieval *op,
+				   struct list_head *pages,
+				   unsigned *nr_pages,
+				   gfp_t gfp)
+{
+	struct cachefiles_object *object;
+	struct cachefiles_cache *cache;
+	struct list_head backpages;
+	struct pagevec pagevec;
+	struct inode *inode;
+	struct page *page, *_n;
+	unsigned shift, nrbackpages;
+	int ret, ret2, space;
+
+	object = container_of(op->op.object,
+			      struct cachefiles_object, fscache);
+	cache = container_of(object->fscache.cache,
+			     struct cachefiles_cache, cache);
+
+	_enter("{OBJ%x,%d},,%d,,",
+	       object->fscache.debug_id, atomic_read(&op->op.usage),
+	       *nr_pages);
+
+	if (!object->backer)
+		return -ENOBUFS;
+
+	space = 1;
+	if (cachefiles_has_space(cache, 0, *nr_pages) < 0)
+		space = 0;
+
+	inode = object->backer->d_inode;
+	ASSERT(S_ISREG(inode->i_mode));
+	ASSERT(inode->i_mapping->a_ops->bmap);
+	ASSERT(inode->i_mapping->a_ops->readpages);
+
+	/* calculate the shift required to use bmap */
+	if (inode->i_sb->s_blocksize > PAGE_SIZE)
+		return -ENOBUFS;
+
+	shift = PAGE_SHIFT - inode->i_sb->s_blocksize_bits;
+
+	pagevec_init(&pagevec, 0);
+
+	op->op.processor = cachefiles_read_copier;
+
+	INIT_LIST_HEAD(&backpages);
+	nrbackpages = 0;
+
+	ret = space ? -ENODATA : -ENOBUFS;
+	list_for_each_entry_safe(page, _n, pages, lru) {
+		sector_t block0, block;
+
+		/* we assume the absence or presence of the first block is a
+		 * good enough indication for the page as a whole
+		 * - TODO: don't use bmap() for this as it is _not_ actually
+		 *   good enough for this as it doesn't indicate errors, but
+		 *   it's all we've got for the moment
+		 */
+		block0 = page->index;
+		block0 <<= shift;
+
+		block = inode->i_mapping->a_ops->bmap(inode->i_mapping,
+						      block0);
+		_debug("%llx -> %llx",
+		       (unsigned long long) block0,
+		       (unsigned long long) block);
+
+		if (block) {
+			/* we have data - add it to the list to give to the
+			 * backing fs */
+			list_move(&page->lru, &backpages);
+			(*nr_pages)--;
+			nrbackpages++;
+		} else if (space && pagevec_add(&pagevec, page) == 0) {
+			fscache_mark_pages_cached(op, &pagevec);
+			ret = -ENODATA;
+		}
+	}
+
+	if (pagevec_count(&pagevec) > 0)
+		fscache_mark_pages_cached(op, &pagevec);
+
+	if (list_empty(pages))
+		ret = 0;
+
+	/* submit the apparently valid pages to the backing fs to be read from
+	 * disk */
+	if (nrbackpages > 0) {
+		ret2 = cachefiles_read_backing_file(object, op, &backpages,
+						    &pagevec);
+		if (ret2 == -ENOMEM || ret2 == -EINTR)
+			ret = ret2;
+	}
+
+	if (pagevec_count(&pagevec) > 0)
+		fscache_mark_pages_cached(op, &pagevec);
+
+	_leave(" = %d [nr=%u%s]",
+	       ret, *nr_pages, list_empty(pages) ? " empty" : "");
+	return ret;
+}
+
+/*
+ * allocate a block in the cache in which to store a page
+ * - cache withdrawal is prevented by the caller
+ * - returns -EINTR if interrupted
+ * - returns -ENOMEM if ran out of memory
+ * - returns -ENOBUFS if no buffers can be made available
+ * - returns -ENOBUFS if page is beyond EOF
+ * - otherwise:
+ *   - the metadata will be retained
+ *   - 0 will be returned
+ */
+int cachefiles_allocate_page(struct fscache_retrieval *op,
+			     struct page *page,
+			     gfp_t gfp)
+{
+	struct cachefiles_object *object;
+	struct cachefiles_cache *cache;
+	struct pagevec pagevec;
+	int ret;
+
+	object = container_of(op->op.object,
+			      struct cachefiles_object, fscache);
+	cache = container_of(object->fscache.cache,
+			     struct cachefiles_cache, cache);
+
+	_enter("%p,{%lx},", object, page->index);
+
+	ret = cachefiles_has_space(cache, 0, 1);
+	if (ret == 0) {
+		pagevec_init(&pagevec, 0);
+		pagevec_add(&pagevec, page);
+		fscache_mark_pages_cached(op, &pagevec);
+	} else {
+		ret = -ENOBUFS;
+	}
+
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * allocate blocks in the cache in which to store a set of pages
+ * - cache withdrawal is prevented by the caller
+ * - returns -EINTR if interrupted
+ * - returns -ENOMEM if ran out of memory
+ * - returns -ENOBUFS if some buffers couldn't be made available
+ * - returns -ENOBUFS if some pages are beyond EOF
+ * - otherwise:
+ *   - -ENODATA will be returned
+ * - metadata will be retained for any page marked
+ */
+int cachefiles_allocate_pages(struct fscache_retrieval *op,
+			      struct list_head *pages,
+			      unsigned *nr_pages,
+			      gfp_t gfp)
+{
+	struct cachefiles_object *object;
+	struct cachefiles_cache *cache;
+	struct pagevec pagevec;
+	struct page *page;
+	int ret;
+
+	object = container_of(op->op.object,
+			      struct cachefiles_object, fscache);
+	cache = container_of(object->fscache.cache,
+			     struct cachefiles_cache, cache);
+
+	_enter("%p,,,%d,", object, *nr_pages);
+
+	ret = cachefiles_has_space(cache, 0, *nr_pages);
+	if (ret == 0) {
+		pagevec_init(&pagevec, 0);
+
+		list_for_each_entry(page, pages, lru) {
+			if (pagevec_add(&pagevec, page) == 0)
+				fscache_mark_pages_cached(op, &pagevec);
+		}
+
+		if (pagevec_count(&pagevec) > 0)
+			fscache_mark_pages_cached(op, &pagevec);
+		ret = -ENODATA;
+	} else {
+		ret = -ENOBUFS;
+	}
+
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * request a page be stored in the cache
+ * - cache withdrawal is prevented by the caller
+ * - this request may be ignored if there's no cache block available, in which
+ *   case -ENOBUFS will be returned
+ * - if the op is in progress, 0 will be returned
+ */
+int cachefiles_write_page(struct fscache_storage *op, struct page *page)
+{
+	struct cachefiles_object *object;
+	struct address_space *mapping;
+	int ret;
+
+	ASSERT(op != NULL);
+	ASSERT(page != NULL);
+
+	object = container_of(op->op.object,
+			      struct cachefiles_object, fscache);
+
+	_enter("%p,%p{%lx},,,", object, page, page->index);
+
+	if (!object->backer) {
+		_leave(" = -ENOBUFS");
+		return -ENOBUFS;
+	}
+
+	ASSERT(S_ISREG(object->backer->d_inode->i_mode));
+
+	/* copy the page to ext3 and let it store it in its own time */
+	mapping = object->backer->d_inode->i_mapping;
+	ret = -EIO;
+	if (mapping->a_ops->write_one_page)
+		ret = mapping->a_ops->write_one_page(mapping, page->index,
+						     page);
+
+	if (ret != 0) {
+		if (ret == -EIO)
+			cachefiles_io_error_obj(
+				object, "Write page to backing file failed");
+		ret = -ENOBUFS;
+	}
+
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * detach a backing block from a page
+ * - cache withdrawal is prevented by the caller
+ */
+void cachefiles_uncache_page(struct fscache_object *_object, struct page *page)
+{
+	struct cachefiles_object *object;
+	struct cachefiles_cache *cache;
+
+	object = container_of(_object, struct cachefiles_object, fscache);
+	cache = container_of(object->fscache.cache,
+			     struct cachefiles_cache, cache);
+
+	_enter("%p,{%lu}", object, page->index);
+
+	spin_unlock(&object->fscache.cookie->lock);
+}
diff --git a/fs/cachefiles/cf-security.c b/fs/cachefiles/cf-security.c
new file mode 100644
index 0000000..f01605b
--- /dev/null
+++ b/fs/cachefiles/cf-security.c
@@ -0,0 +1,114 @@
+/* CacheFiles security management
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/fs.h>
+#include "cf-internal.h"
+
+/*
+ * determine the security context within which we access the cache from within
+ * the kernel
+ */
+int cachefiles_get_security_ID(struct cachefiles_cache *cache)
+{
+	char *seclabel;
+	u32 seclen, daemon_secid;
+	int ret;
+
+	_enter("");
+
+	cache->access_secid = 0;
+
+	/* ask the security policy to tell us what security ID we should be
+	 * using to access the cache, given the security ID that our daemon is
+	 * using */
+	security_task_getsecid(current, &daemon_secid);
+
+	ret = security_secid_to_secctx(daemon_secid, &seclabel, &seclen);
+	if (ret < 0)
+		goto error;
+	_debug("Cache Daemon SecID: %x '%s'", daemon_secid, seclabel);
+	kfree(seclabel);
+
+	ret = security_cachefiles_get_secid(daemon_secid, &cache->access_secid);
+	if (ret < 0) {
+		printk(KERN_ERR "CacheFiles:"
+		       " Security can't provide module SecID: error %d",
+		       ret);
+		goto error;
+	}
+
+	ret = security_secid_to_secctx(cache->access_secid, &seclabel, &seclen);
+	if (ret < 0)
+		goto error;
+	_debug("Cache Module SecID: %x '%s'", cache->access_secid, seclabel);
+	kfree(seclabel);
+
+error:
+	if (ret == -EOPNOTSUPP)
+		ret = 0;
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * check the security details of the on-disk cache
+ * - must be called with security imposed
+ */
+int cachefiles_determine_cache_secid(struct cachefiles_cache *cache,
+				     struct dentry *root)
+{
+	char *seclabel;
+	u32 seclen;
+	int ret;
+
+	_enter("");
+
+	/* use the cache root dir's security ID as the SECID with which to create
+	 * files */
+	ret = security_inode_get_secid(root->d_inode, &cache->cache_secid);
+	if (ret < 0) {
+		printk(KERN_ERR "CacheFiles:"
+		       " Security can't provide cache root inode SecID:"
+		       " error %d",
+		       ret);
+		goto error;
+	}
+
+	ret = security_secid_to_secctx(cache->cache_secid, &seclabel, &seclen);
+	if (ret < 0)
+		goto error;
+	_debug("Cache SecID: %x '%s'", cache->cache_secid, seclabel);
+	kfree(seclabel);
+
+	/* check that we have permission to create files and directories with
+	 * the security ID we've been given */
+	ret = security_inode_mkdir(root->d_inode, root, 0);
+	if (ret < 0) {
+		printk(KERN_ERR "CacheFiles:"
+		       " Security denies permission to make dirs: error %d",
+		       ret);
+		goto error;
+	}
+
+	ret = security_inode_create(root->d_inode, root, 0);
+	if (ret < 0) {
+		printk(KERN_ERR "CacheFiles:"
+		       " Security denies permission to create files: error %d",
+		       ret);
+		goto error;
+	}
+
+error:
+	if (ret == -EOPNOTSUPP)
+		ret = 0;
+	_leave(" = %d", ret);
+	return ret;
+}
diff --git a/fs/cachefiles/cf-xattr.c b/fs/cachefiles/cf-xattr.c
new file mode 100644
index 0000000..9ae9240
--- /dev/null
+++ b/fs/cachefiles/cf-xattr.c
@@ -0,0 +1,292 @@
+/* CacheFiles extended attribute management
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/fsnotify.h>
+#include <linux/quotaops.h>
+#include <linux/xattr.h>
+#include "cf-internal.h"
+
+static const char cachefiles_xattr_cache[] =
+	XATTR_USER_PREFIX "CacheFiles.cache";
+
+/*
+ * check the type label on an object
+ * - done using xattrs
+ */
+int cachefiles_check_object_type(struct cachefiles_object *object)
+{
+	struct dentry *dentry = object->dentry;
+	char type[3], xtype[3];
+	int ret;
+
+	ASSERT(dentry);
+	ASSERT(dentry->d_inode);
+
+	if (!object->fscache.cookie)
+		strcpy(type, "C3");
+	else
+		snprintf(type, 3, "%02x", object->fscache.cookie->def->type);
+
+	_enter("%p{%s}", object, type);
+
+	/* attempt to install a type label directly */
+	ret = vfs_setxattr(dentry, cachefiles_xattr_cache, type, 2,
+			   XATTR_CREATE);
+	if (ret == 0) {
+		_debug("SET"); /* we succeeded */
+		goto error;
+	}
+
+	if (ret != -EEXIST) {
+		kerror("Can't set xattr on %*.*s [%lu] (err %d)",
+		       dentry->d_name.len, dentry->d_name.len,
+		       dentry->d_name.name, dentry->d_inode->i_ino,
+		       -ret);
+		goto error;
+	}
+
+	/* read the current type label */
+	ret = vfs_getxattr(dentry, cachefiles_xattr_cache, xtype, 3);
+	if (ret < 0) {
+		if (ret == -ERANGE)
+			goto bad_type_length;
+
+		kerror("Can't read xattr on %*.*s [%lu] (err %d)",
+		       dentry->d_name.len, dentry->d_name.len,
+		       dentry->d_name.name, dentry->d_inode->i_ino,
+		       -ret);
+		goto error;
+	}
+
+	/* check the type is what we're expecting */
+	if (ret != 2)
+		goto bad_type_length;
+
+	if (xtype[0] != type[0] || xtype[1] != type[1])
+		goto bad_type;
+
+	ret = 0;
+
+error:
+	_leave(" = %d", ret);
+	return ret;
+
+bad_type_length:
+	kerror("Cache object %lu type xattr length incorrect",
+	       dentry->d_inode->i_ino);
+	ret = -EIO;
+	goto error;
+
+bad_type:
+	xtype[2] = 0;
+	kerror("Cache object %*.*s [%lu] type %s not %s",
+	       dentry->d_name.len, dentry->d_name.len,
+	       dentry->d_name.name, dentry->d_inode->i_ino,
+	       xtype, type);
+	ret = -EIO;
+	goto error;
+}
+
+/*
+ * set the state xattr on a cache file
+ */
+int cachefiles_set_object_xattr(struct cachefiles_object *object,
+				struct cachefiles_xattr *auxdata)
+{
+	struct dentry *dentry = object->dentry;
+	int ret;
+
+	ASSERT(object->fscache.cookie);
+	ASSERT(dentry);
+
+	_enter("%p,#%d", object, auxdata->len);
+
+	/* attempt to install the cache metadata directly */
+	_debug("SET %s #%u", object->fscache.cookie->def->name, auxdata->len);
+
+	ret = vfs_setxattr(dentry, cachefiles_xattr_cache,
+			   &auxdata->type, auxdata->len,
+			   XATTR_CREATE);
+	if (ret < 0 && ret != -ENOMEM)
+		cachefiles_io_error_obj(
+			object,
+			"Failed to set xattr with error %d", ret);
+
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * update the state xattr on a cache file
+ */
+int cachefiles_update_object_xattr(struct cachefiles_object *object,
+				   struct cachefiles_xattr *auxdata)
+{
+	struct dentry *dentry = object->dentry;
+	int ret;
+
+	ASSERT(object->fscache.cookie);
+	ASSERT(dentry);
+
+	_enter("%p,#%d", object, auxdata->len);
+
+	/* attempt to install the cache metadata directly */
+	_debug("SET %s #%u", object->fscache.cookie->def->name, auxdata->len);
+
+	ret = vfs_setxattr(dentry, cachefiles_xattr_cache,
+			   &auxdata->type, auxdata->len,
+			   XATTR_REPLACE);
+	if (ret < 0 && ret != -ENOMEM)
+		cachefiles_io_error_obj(
+			object,
+			"Failed to update xattr with error %d", ret);
+
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * check the state xattr on a cache file
+ * - return -ESTALE if the object should be deleted
+ */
+int cachefiles_check_object_xattr(struct cachefiles_object *object,
+				  struct cachefiles_xattr *auxdata)
+{
+	struct cachefiles_xattr *auxbuf;
+	struct dentry *dentry = object->dentry;
+	int ret;
+
+	_enter("%p,#%d", object, auxdata->len);
+
+	ASSERT(dentry);
+	ASSERT(dentry->d_inode);
+
+	auxbuf = kmalloc(sizeof(struct cachefiles_xattr) + 512, GFP_KERNEL);
+	if (!auxbuf) {
+		_leave(" = -ENOMEM");
+		return -ENOMEM;
+	}
+
+	/* read the current type label */
+	ret = vfs_getxattr(dentry, cachefiles_xattr_cache,
+			   &auxbuf->type, 512 + 1);
+	if (ret < 0) {
+		if (ret == -ENODATA)
+			goto stale; /* no attribute - power went off
+				     * mid-cull? */
+
+		if (ret == -ERANGE)
+			goto bad_type_length;
+
+		cachefiles_io_error_obj(object,
+					"Can't read xattr on %lu (err %d)",
+					dentry->d_inode->i_ino, -ret);
+		goto error;
+	}
+
+	/* check the on-disk object */
+	if (ret < 1)
+		goto bad_type_length;
+
+	if (auxbuf->type != auxdata->type)
+		goto stale;
+
+	auxbuf->len = ret;
+
+	/* consult the netfs */
+	if (object->fscache.cookie->def->check_aux) {
+		fscache_checkaux_t result;
+		unsigned int dlen;
+
+		dlen = auxbuf->len - 1;
+
+		_debug("checkaux %s #%u",
+		       object->fscache.cookie->def->name, dlen);
+
+		result = object->fscache.cookie->def->check_aux(
+			object->fscache.cookie->netfs_data,
+			&auxbuf->data, dlen);
+
+		switch (result) {
+			/* entry okay as is */
+		case FSCACHE_CHECKAUX_OKAY:
+			goto okay;
+
+			/* entry requires update */
+		case FSCACHE_CHECKAUX_NEEDS_UPDATE:
+			break;
+
+			/* entry requires deletion */
+		case FSCACHE_CHECKAUX_OBSOLETE:
+			goto stale;
+
+		default:
+			BUG();
+		}
+
+		/* update the current label */
+		ret = vfs_setxattr(dentry, cachefiles_xattr_cache,
+				   &auxdata->type, auxdata->len,
+				   XATTR_REPLACE);
+		if (ret < 0) {
+			cachefiles_io_error_obj(object,
+						"Can't update xattr on %lu"
+						" (error %d)",
+						dentry->d_inode->i_ino, -ret);
+			goto error;
+		}
+	}
+
+okay:
+	ret = 0;
+
+error:
+	kfree(auxbuf);
+	_leave(" = %d", ret);
+	return ret;
+
+bad_type_length:
+	kerror("Cache object %lu xattr length incorrect",
+	       dentry->d_inode->i_ino);
+	ret = -EIO;
+	goto error;
+
+stale:
+	ret = -ESTALE;
+	goto error;
+}
+
+/*
+ * remove the object's xattr to mark it stale
+ */
+int cachefiles_remove_object_xattr(struct cachefiles_cache *cache,
+				   struct dentry *dentry)
+{
+	int ret;
+
+	ret = vfs_removexattr(dentry, cachefiles_xattr_cache);
+	if (ret < 0) {
+		if (ret == -ENOENT || ret == -ENODATA)
+			ret = 0;
+		else if (ret != -ENOMEM)
+			cachefiles_io_error(cache,
+					    "Can't remove xattr from %lu"
+					    " (error %d)",
+					    dentry->d_inode->i_ino, -ret);
+	}
+
+	_leave(" = %d", ret);
+	return ret;
+}

