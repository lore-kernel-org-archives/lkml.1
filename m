Return-Path: <linux-kernel-owner+w=401wt.eu-S1161543AbXDYMrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161543AbXDYMrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 08:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965522AbXDYMrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 08:47:51 -0400
Received: from [212.12.190.172] ([212.12.190.172]:32918 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965211AbXDYMrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 08:47:49 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Reasons to merge suspend2.
Date: Wed, 25 Apr 2007 15:51:38 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200704251551.38373.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't read your whole post, it's way too long, but I would like to see 
your patch in mainline as an option to swsusp.  What would make this 
infeasible?


Thanks!

--
Al

---

Nigel Cunningham wrote:
> Hi all.
>
> I've been working on this email on and off for a while, but since Pavel
> raised the issue again, I thought I should make a concerted effort to
> finish it...
>
> In this email, I'm going to outline the problems with the current design
> (uswsusp and swsusp) and the ways in which Suspend2 overcomes those
> limitations, before going on to outline the additional advantages
> Suspend2 has for users and address objections previously raised against
> merging Suspend2.
>
> A) Problems with the current design.
> ====================================
> 1) Ordering of operations.
>
> The current [u]swsusp design doesn't do things in discrete, well ordered
> stages. Storage for the image is not allocated until after the atomic
> copy has been done. This means that the process can fail when we are a
> significant portion of the way into suspending, and it means it can fail
> when the user will seriously expect it to run to completion. The
> solution to this issue is simple: separate preparing to suspend from
> actually writing the image. In the preparation step, ensure, so far as
> you are able, that there will be sufficient memory and sufficient
> storage to complete the process, and don't write anything or do any
> atomic copying until after that has been done.
>
> The only valid objection I can think of is that you can't know for
> certain prior to doing the atomic copy how much memory & storage will be
> needed for allocations by driver suspend methods. That can be addressed
> by a simple extension of the driver model, where in drivers could report
> how many pages they will need. (If slab will be needed, the worst case
> can be assumed). Rafael's notify patches (recently posted) also help in
> that area.
>
> Once processes are frozen, all significant memory usage can be accounted
> for, because the process doing the suspending will be the only one
> allocating memory.
>
> 2) Limit on image size.
>
> The current implementation limits the size of an image to an absolute
> maximum of half the amount of ram. This is certainly an improvement over
> the old days where it sought to free everything it could, but it's still
> not good enough. Current memory freeing code doesn't free the exact
> amount requested; often far more than has been requested is freed. This
> does not only result in a smaller image. It also means the system is
> proportionately less responsive on resume at whatever stage that those
> pages are needed again. A full image is certainly not needed by
> everyone. Those with huge amounts of memory, very fast storage devices
> or particular memory usage patterns may, quite rightly, not want to
> store the whole lot in an image. This doesn't mean, however, that those
> who want or need (from their perspective) a full image of memory
> shouldn't be able to have it. It just adds to the argument for making it
> tunable (which swsusp has done too).
>
> 3) Lack of provision for tuning to individual needs.
>
> Swsusp historically included very little provision whatsoever for the
> user to tune their configuration. This has recently begun to change, and
> I applaud that. But it needs to go further. Suspending to disk is not a
> one-size-fits-all situation. People have different hardware
> configurations, with the result being that some people benefit from
> compression while others do better without it. Some people want
> encryption in a particular configuration while others don't care about
> encryption at all. Some people want to limit the image size, others
> don't. Sometimes a user might want to reboot instead of powering down
> (dual booting). All of this should be doable, without having to hack the
> code or recompile the kernel, and should be as simple as possible.
> Suspend2, via its /sys/power/suspend2 interface and hibernate-script
> porcelain, makes this easy.
>
> 4) No support for multiple swap devices / non swap storage.
>
> Until recently, [u]swsusp supported a single swap partition only.
> Support for a swap file has been added, but [u]swsusp still supports
> only one swap device at a time. For most people, this is adequate, but
> this doesn't mean everyone should be forced to fit this mould.
>
> [u]swsusp also lacks support for storage to non-swap. Particularly in
> systems that rely on swap for normal activity, this can make [u]swsusp
> less reliable. The amount of swap available varies according to
> workload, so sometimes the user will be unable to suspend. To address
> this raciness/competition against other swap usage, Suspend2 supports
> writing to a generic file, either a partition or a file on an ordinary
> partition.
>
> B) Further advantages of Suspend2.
> ==================================
> 1) Improvements over swsusp.
> ----------------------------
> a) Modular design.
>
> Parts of Suspend2 implement support for storing an image in swap or in a
> file, using cryptoapi for compression and/or encryption and talking to a
> userspace user interface via a netlink socket. Suspend2 works just fine
> without CONFIG_SWAP, CONFIG_NET and/or CONFIG_CRYPTOAPI, however,
> because it uses a modular design wherein support for these subsystems is
> abstracted (not to be confused with kernel modules). If you disable swap
> support, for example, one file is simply not built. The number of
> #ifdefs in Suspend2 is thus minimal.
>
> In addition, the modular design made modifications such as switching
> from internal compression and encryption support to cryptoapi simple and
> painless. All of the required modifications were found in compression.c,
> encryption.c and Kconfig in kernel/power. The old and new
> implementations could even co-exist if so desired. I recently dropped
> encryption support (after deciding the existing support in block dev
> drivers was more than adequate). This took five minutes tops - remove
> the .c and modify the Makefile and Kconfig.
>
> The modular design also helps with implementing the user interface. Each
> module gets its own subdirectory in /sys/power/suspend2, so the top
> level directory is not cluttered and it's easier to find what you're
> after. Switching from /proc/suspend2 to /sys/power/suspend2 required
> modifications to just two main routines (one for reading and one for
> writing entries).
>
> b) Compression support.
>
> Swsusp has no support for compressing an image. Suspend2 has optional
> cryptoapi based support for compressiing the image, and includes a patch
> to add an LZF based compressor to cryptoapi. When this support is used,
> the speed of reading (and to a lesser extent writing) the image is
> generally in the region of being doubled.
>
> c) Optional image size limit.
>
> Suspend2 also implements an optional, user specified soft limit on the
> image size. If set to a positive value, it is interpreted as a number of
> megabytes and Suspend2 attempts to free memory to keep the image size
> within this limit, but won't abort the cycle if this limit isn't met. If
> set to -1, Suspend2 will refuse to free any memory, and will abort if
> other criteria for suspending aren't satisfied. If set to -2, it will
> drop filesystem caches (equivalent to echo 1 > /proc/sys/vm/drop_caches)
> prior to suspending, but will not otherwise eat memory unless necessary.
> d) Cryptoapi based compression.
>
> Suspend2 uses cryptoapi for compression. Swsusp includes no built in
> support for compression.
>
> 2) Improvements over uswsusp.
> -----------------------------
> a) Simpler to set up.
>
> The heart of Suspend2 is implemented in the kernel so, unlike uswsusp,
> there is no need for the user to download and install userspace
> libraries, build a userspace app and figure out how to create and update
> an initrd or initramfs. In most situations, it just works. (The
> exception is LVM and such like, where both implementations require
> userspace apps to set up access to the logical volumes (or encrypted
> volumes) before they can be used for resuming).
>
> b) No unnecessary copying of data.
>
> uswsusp copies the image to userspace and back again. It may compress
> the data in userspace. But none of this is necessary. There is a
> perfectly good compression and encryption library in the form of
> cryptoapi already in the kernel. Suspend2 uses this. uswsusp could too.
>
> c) API changes far less critical.
>
> Modifications to the API between kernel and userspace can cause big
> headaches for uswsusp (see, eg, the recent issue with running a 32 bit
> suspend program on a 64 bit kernel, recently raised by Johannes Berg on
> the linux-pm mailing list).
>
> In Suspend2's case, userspace programs only handle the user interface.
> If an API mismatch does occur, the issue will not void the user's
> ability to suspend or resume.
>
> 3) Completely New Functionality/Improvements.
> ---------------------------------------------
> a) Filewriter.
>
> Using swap to store the image is inherently racy. To be able to suspend,
> we need enough free memory and enough free storage. But getting enough
> free memory might involve swapping out some memory, which reduces the
> amount of available storage, which might require more free memory.
>
> It is true that most of the time this race isn't an issue. Nevertheless,
> that's the nature of races.
>
> Suspend2 implements support for files as a means of avoiding this issue.
> Thus, it is much more reliable in low memory situations than swsusp or
> uswsusp.
>
> b) Multiple swap devices.
>
> Suspend2 supports writing an image to multiple swap devices, whereas
> uswsusp and swsusp only write to one device.
>
> c) Full image of memory.
>
> Suspend2 implements support for writing a full image of memory. You thus
> get a more responsive system post-resume; just as responsive as if you'd
> never suspended. This support can be disabled via a sysfs entry
> (no_pageset2).
>
> d) Keep image mode.
>
> Suspend2 supports keeping the image after resuming. This is used in
> kiosk systems where nothing is written to the filesystem or changes are
> written to a separate filesystem that is mounted after resume and
> unmounted before suspending or powering off.
>
> e) Ability to cancel a cycle.
>
> Suspend2 allows the user to cancel a cycle (and this ability can be
> disabled). This means you don't have to wait for the system to finish
> suspending, then resume it to get your system back. If done prior to the
> atomic copy, you have it back instantly. If afterwards, a small portion
> of the image is read first.
>
> f) Scripting support.
>
> Suspend2 allows scripts to check whether an image exists
> (cat /sys/power/suspend2/have_image), remove one (echo 0 > have_image),
> and set the location of the image header (echo /dev/hda1 > resume2). One
> user utilises this support to provide an initrd/ramfs based menu of
> previously suspended live-cd images. This could also be used in a lab
> environment with homogeneous computer specifications to allow resuming
> to a login screen, then resuming the image of a user's previous session
> once they have logged in.
> g) Userspace user interface.
>
> Suspend2 provides userspace based user interface programs that
> communicate with the core code via a netlink socket. This allows the
> user to have all the eyecandy they want (although it might slow
> suspending!), without the code needing to run in kernelspace or
> compromise the integrity of the image.
>
> h) Early messages.
>
> Suspend2 provides user-friendly handling of error conditions early in
> the boot process. Sanity checks on the image are done before loading it,
> and if it looks like the user has (for example) accidentally booted the
> wrong kernel, Suspend2 will warn them and allow them to reboot into the
> right kernel, or invalidate the image and carry on booting. This has a
> 25 second timeout and sensible default, so the kernel will not hang
> forever.
>
> i) Powerdown methods.
>
> Suspend2 supports a greater variety of methods of powering down once the
> image has been written. It can enter ACPI states S3, S4 or S5, use a
> non-ACPI power off or resume an alternate image.
>
> S3 was recently picked up by uswsusp, but isn't supported by swsusp. It
> allows the user to suspend to ram instead of powering down after writing
> the image. If the battery runs out, we resume as if they'd fully powered
> off. If it doesn't, we act like the cycle was cancelled at the last
> moment, reloading a small portion of the image (pages that were
> overwritten by the atomic copy) before giving control back to the user.
>
> The support for resuming an alternate image is primarily useful for a
> lab/multi-distro environment. It has the same limitations regarding
> mounted filesystems that normally apply, but otherwise provides a way to
> switch between images quickly and easily. (One image could be a log-in
> screen/image selection menu, and the other individual users or distros
> sessions).
>
> j) Transparent swsusp replacement.
>
> Suspend2 also implements optional replacement of swsusp. When enabled,
> echo disk > /sys/power/state will activate Suspend2, resume= will
> override resume2= and noresume will also function as noresume2. Finally,
> activating a swsusp resume will also cause Suspend2 to check whether to
> resume (we don't know until we check whether the replacing of swsusp was
> enabled when we suspended or not). A compile time option allows the user
> to enable or disable this functionality by default.
> k) Expected compression ratio.
>
> Suspend2 allows the user to set an expected compression ratio. This
> allows the user to store a larger image than might otherwise be
> possible, particularly in situations where available storage is less
> than the amount of memory in use. Let's imagine, for example, that the
> user has 1GB of RAM and a 600MB swap partition or file. Without an
> expected compression ratio, Suspend2 would always store at most 600MB in
> the image. With an expected compression ratio of 50% (common for LZF),
> Suspend2 will not free memory even if there's the full gigabyte of
> memory in use, because it will assume that the compressed image will fit
> in 500MB.
>
> l) Simpler swap file support.
>
> Suspend2 makes using a swap file much simpler. The user simply needs to
> swapon the file, then cat /sys/power/suspend2/swap/header_locations:
>
> # cat /sys/power/suspend2/swap/headerlocations
> For swap partitions, simply use the format: resume2=swap:/dev/hda1.
> For swapfile `/blot/swapfile`, use resume2=swap:/dev/hda6:0xf4000.
> #
> m) Multithreaded i/o.
>
> With the recent move to doing cpu hotplugging just prior to the atomic
> copy, rather than right at the start of the cycle, the possibility has
> been opened up of using multiple cores to do the image de/compression.
> Suspend2 now includes this. The performance improvement has been
> particularly seen during compression, where the speed on a dual core P4
> came up to the same as seen in reading the image (ie approximately
> double that achieved without compression). This support is disabled by
> default at the moment, while upstream work on interactions between cpu
> hotplugging and freezing are resolved.
>
> 4) Support.
> -----------
> Suspend2 has very active support in mailing lists, a web site, bugzilla
> and wiki. Nigel is not going to refuse to deal with people because their
> kernel is tainted or isn't the latest release.
>
> C) Objections to merging Suspend2.
> ==================================
> 1) Size of the patch.
>
> These objections seem to have been dealt with in this morning's
> discussions already. The only thing I would add is that the Suspend2
> patch size is somewhat inflated by documentation. The 16000 lines quoted
> includes 1100 lines of Changelog and another 1100 of documents
> describing how it works and how to use it.
>
> 2) "It should be done in parts"
> Since we have a modular design, some parts, such as compression and
> support for writing to ordinary files can clearly be handled separately.
>
> A comparison of the core code with that in swsusp would, however, show
> that Suspend2 is far more than just a bolting on of addition features to
> swsusp. Substantial changes in the basic method of operation have been
> made (see esp 1A above) which would make the task far larger and more
> complicated than it needs to be.
>
> While swsusp could, therefore, be mutated into suspend2 over time, I
> believe it is far more straightforward and simple to just merge
> suspend2, let the two coexist for a while and then drop swsusp when
> people are satisfied that suspend2 is an adequate replacement.
>
> A tangential (but important) issue is that I simply don't have the time
> to do the incremental modifications to swsusp.
>
> 3) It's not needed.
>
> It is true that swsusp is perfectly adequate for some people. This
> doesn't, however, mean that it meets the needs of all people.
>
> To put it bluntly, if Suspend2 wasn't needed, I wouldn't be working on
> it. I have more than enough in the way of other things that I'd rather
> be doing, but as a user, I want more than swsusp or uswsusp deliver, so
> I continue to work on Suspend2.
>
> 4) [u]swsusp will/could implement it in the future.
>
> At the last review, Pavel replied to many of the points about Suspend2
> features that swsusp lacks by saying 'uswsusp can do this'. But the
> facts are that uswsusp is very slow to get these new features - the
> previous revision of this paragraph had (and I believe it was accurate)
> "has no new features over swsusp at the moment". Furthermore, it would
> probably not be unreasonable to argue that if Suspend2 didn't have these
> features, uswsusp would never have gotten them.
>
> Hope this helps,
>
> Nigel

