Return-Path: <linux-kernel-owner+w=401wt.eu-S1764886AbXFRSMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764886AbXFRSMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764756AbXFRSMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:12:30 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:4983 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764525AbXFRSM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:12:28 -0400
Date: Mon, 18 Jun 2007 20:12:25 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
       y-goto@jp.fujitsu.com
Subject: Re: 2.6.22-rc5 regression
Message-ID: <20070618181225.GB8054@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
	y-goto@jp.fujitsu.com
References: <20070617182254.GA17595@alinoe.com> <20070617195805.GA6125@alinoe.com> <20070617214905.GA6207@alinoe.com> <alpine.LFD.0.98.0706180950130.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706180950130.14121@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 10:01:34AM -0700, Linus Torvalds wrote:
> On Sun, 17 Jun 2007, Carlo Wood wrote:
> > 
> > If you want my opinion on this: git bisect is broken :p
> > I was very surprised that it printed this at this point.
> 
> Hmm. Possible. However, I *really* would need the git bisect log to see 
> what's up.

I had already done a git bisect reset :/

> So far, we have never seen a bug in "git bisect" that wasn't 
> either due to the user specifying path-names to limit the testing (and the 
> bug not being in that set of path-names), or the user not realizing that 
> with non-linear history the "git bisect" is actually a fairly complex op.

I realize that it is non-linear - and I didn't do anything to "speed
things up". Just build -> boot -> git bisect good/bad -> build etc.

> That said, "git bisect" _can_ give the "wrong" results in the sense that 
> the commit it points to may not be the one you are actually looking for, 
> if:
> 
>  - the bug is sporadic, and not entirely repeatable, and a kernel you 
>    marked as good wasn't really good, your test just didn't happen to 
>    catch it that time around.
> 
>  - the bug comes and goes, and the commit that "git bisect" pinpoints may 
>    well *show* the bug, but may not be the *cause* of the bug (ie there 
>    might be two or more independent things that have to come together for 
>    the bug to trigger, and as a result there is not a "single" commit that 
>    acts as a clear boundary)

I don't believe that either of these is the case. I have booted
about 8 different kernel revisions several times (most three times),
alternating between them (not the same three times on a row) and the
ones that boot correctly always booted correctly, while the ones that
hung, always hung (although in a totally reproducable way).

Nevertheless, it is not 100% impossible. I have the feeling that it
MIGHT be related to the fact that I have 4 CPU's - and that perhaps some
race condition is involved. And if that is the case, then there might be
some kernel version where boot/not-boot is less reliable then with the
eight I tested - apart from that three times isn't very much (but doing
it for four good kernels and two bad kernels, it still is a reasonable
indication for reproducability).

> But hey, a bug in "git bisect" is certainly _possible_. I just consider it 
> fairly unlikely by now. 
> > One bisect before, it said there were still 96 revision to check.
> > 
> > Anyway - here are some facts of the kernels that I tested:
> 
> You seem to not actually have used "git bisect" to generate this list.

I didn't -- what is the command to generate a list like this with git?

> Quite frankly, the most likely cause for the bad bisection result is that 
> you have not used "git bisect" at all to let it pick the bisection points. 

Heh - now you are insulting me :p  I said I did, and I did.
The reason that I made that list manually is because wanted to have more
overview. I use this alias to build the kernels:

hikaru:/usr/src/kernel/git/linux-2.6>alias build
alias build='cp /boot/config-2.6.22-rc4-hikaru-amd64 .config &&
make-kpkg clean && VER=$(date +"%Y%m%d%H%M") && BRANCH=$(git branch |
grep "^\*" | sed -e "s/\* //") && NAMEEXT="-$BRANCH-$(git rev-list
--max-count=1 $BRANCH)-$(dpkg-architecture -qDEB_HOST_ARCH)" &&
make-kpkg --revision=$VER --append-to-version=-$NAMEEXT --rootcmd
fakeroot clean && make-kpkg --revision=$VER --append-to-version=$NAMEEXT
--rootcmd fakeroot --initrd kernel_image modules_image'

That results in debian kernel package names like:

-rw-r--r--  1 carlo carlo 18790180 2007-06-17 22:55 linux-image-2.6.22-rc4-bisect-d09c6b809432668371b5de9102f4f9aa6a7c79cc-amd64_200706172247_amd64.deb
-rw-r--r--  1 carlo carlo 18790446 2007-06-17 22:42 linux-image-2.6.22-rc4-bisect-ce9b2b0abbf019d5259eb089a1cc256852930f67-amd64_200706172234_amd64.deb
-rw-r--r--  1 carlo carlo 18789884 2007-06-17 22:24 linux-image-2.6.22-rc4-bisect-d1be0a8225f2cb1cdc356ebb0ae6800f023ce67d-amd64_200706172216_amd64.deb
-rw-r--r--  1 carlo carlo 18790420 2007-06-17 22:09 linux-image-2.6.22-rc4-bisect-de7f928ca460005086a8296be07c217aac4b625d-amd64_200706172201_amd64.deb
-rw-r--r--  1 carlo carlo 18790430 2007-06-17 21:04 linux-image-2.6.22-rc4-bisect-3e903e7b1605aff88d7f89a96fab5e43081b914f-amd64_200706172032_amd64.deb
-rw-r--r--  1 carlo carlo 18789698 2007-06-17 20:21 linux-image-2.6.22-rc4-bisect-cf68676222e54cd0a31efd968da00e65f9a0963f-amd64_200706172012_amd64.deb
-rw-r--r--  1 carlo carlo 18789796 2007-06-17 18:51 linux-image-2.6.22-rc5-master-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64_200706171843_amd64.deb
-rw-r--r--  1 carlo carlo 18814550 2007-06-17 17:53 linux-image-2.6.22-rc1-bisect-c4ca881796b7e14120851ddf6e04845ef94a314a-amd64_200706171745_amd64.deb
-rw-r--r--  1 carlo carlo 18814168 2007-06-17 17:14 linux-image-2.6.22-rc1-bisect-9614ece14f23f2ce54a076c471aec9c91e51e79c-amd64_200706171646_amd64.deb
-rw-r--r--  1 carlo carlo 18815254 2007-06-17 07:25 linux-image-2.6.22-rc1-bisect-df80b148869291621ddf51eb8716658d5bfba811-amd64_200706170717_amd64.deb
-rw-r--r--  1 carlo carlo 18826878 2007-06-17 06:36 linux-image-2.6.22-rc4-bisect-b44c0267b7571b449e05f390349c4e4d080f0f4c-amd64_200706170628_amd64.deb
-rw-r--r--  1 carlo carlo 18826402 2007-06-17 04:20 linux-image-2.6.22-rc4-bisect-e141d999b682cda9907179e3b843acb64c34a1d8-amd64_200706170412_amd64.deb
-rw-r--r--  1 carlo carlo 18830334 2007-06-17 03:30 linux-image-2.6.22-rc4-bisect-3334500b460a5eede2e3466ca97a90fe3b91ceb5-amd64_200706170323_amd64.deb
-rw-r--r--  1 carlo carlo 18827134 2007-06-17 02:50 linux-image-2.6.22-rc4-bisect-bb3d2dd72302ea3eefcc6738cdd39ed5864b62f8-amd64_200706170243_amd64.deb
-rw-r--r--  1 carlo carlo 18824900 2007-06-17 02:37 linux-image-2.6.22-rc4-bisect-1a539a87280b3032fd12bc93a4a82f1d8aa97ca8-amd64_200706170230_amd64.deb
-rw-r--r--  1 carlo carlo 18829904 2007-06-16 16:24 linux-image-2.6.22-rc4-master-99f9f3d49cbc7d944476f6fde53a77ec789ab2aa-amd64_200706161616_amd64.deb
-rw-r--r--  1 carlo carlo 18818812 2007-06-16 05:59 linux-image-2.6.22-rc4-master-5ecd3100e695228ac5e0ce0e325e252c0f11806f-amd64_200706160551_amd64.deb
-rw-r--r--  1 carlo carlo 18818284 2007-06-15 21:39 linux-image-2.6.22-rc3-bisect-c420bc9f09a0926b708c3edb27eacba434a4f4ba-amd64_200706152131_amd64.deb
-rw-r--r--  1 carlo carlo 18823918 2007-06-15 21:26 linux-image-2.6.22-rc4-bisect-5ecd3100e695228ac5e0ce0e325e252c0f11806f-amd64_200706152119_amd64.deb
-rw-r--r--  1 carlo carlo 18817072 2007-06-15 18:13 linux-image-2.6.22-rc3-bisect-0e9871df2389560e94ba01e40959140ee56def4b-amd64_200706151805_amd64.deb
-rw-r--r--  1 carlo carlo 18815324 2007-06-15 17:41 linux-image-2.6.22-rc2-bisect-55b637c6a003a8c4850b41a2c2fd6942d8a7f530-amd64_200706151733_amd64.deb

or after installation:

||/ Name                                                                          Version                             Description
ii linux-image-2.6.22-rc4-bisect-3e903e7b1605aff88d7f89a96fab5e43081b914f-amd64   200706172032                        Linux kernel binary image for version 2.6.22

and kernel versions like 2.6.22-rc4-bisect-3e903e7b1605aff88d7f89a96fab5e43081b914f-amd64 etc.
Heh - hopefully you have 20" monitors like met :p

However - it didn't give me an overview of the git bisect good/bad
process. Therefore I used 'gitk -all' and it's search function to
find all the kernels that I tested and put them in a file, such
creating that list I posted here. If there is a way to generate
this list with a command, please tell me :)

> That really doesn't work. If you start giving "git bisect" points to test 
> that aren't "within" the space of points you had already told git bisect 
> about, you're no longer bisecting, you're giving it random points.

Some online documention said you can use git reset --hard gitId to
choose a different point nearby what git bisect 'suggests' to test next.
I didn't do that in this case however.

> > I'd appreciate any suggestions or questions at this point, as I have no
> > idea what to do next to find this problem.
> 
> If you do a real "git bisect", and don't just give it random points that 
> you want to check (you obviously _do_ need to give it one "good" and one 
> "bad" initially, but after that you *have* to pick a point that is within 
> the query space), you'll not get any sensible values out of git bisect.

I suppose you mean: ... then you WILL get sensible values out of git
bisect. But, since I already did a real "git bisect" without giving it
random points, I am afraid you jumped conclusions.

> "git bisect" will also give you a log in ".git/BISECT_LOG", which others 
> can use to follow your bisection. That might be useful to see.

No such file exists (anymore).

However, I can easily reproduce it. From my history file I can see that I started with:

   git bisect start
   git bisect bad v2.6.22-rc5
   git bisect good 99f9f3d49cbc7d944476f6fde53a77ec789ab2aa

I wrote everything down on paper (the git id's and whether they
were good or bad), so I can reproduce it with:

hikaru:/usr/src/kernel/git/linux-2.6>git bisect start
hikaru:/usr/src/kernel/git/linux-2.6>git bisect bad v2.6.22-rc5
hikaru:/usr/src/kernel/git/linux-2.6>git bisect good 99f9f3d49cbc7d944476f6fde53a77ec789ab2aa
Bisecting: 128 revisions left to test after this
D       include/asm-blackfin/macros.h
M       scripts/package/Makefile
D       scripts/package/builddeb
[cf68676222e54cd0a31efd968da00e65f9a0963f] Blackfin serial driver: actually implement the break_ctl() function
hikaru:/usr/src/kernel/git/linux-2.6>git bisect good
Bisecting: 111 revisions left to test after this
D       include/asm-blackfin/macros.h
M       scripts/package/Makefile
D       scripts/package/builddeb
[3e903e7b1605aff88d7f89a96fab5e43081b914f] cpuset: zero malloc - fix for old cpusets
hikaru:/usr/src/kernel/git/linux-2.6>git bisect bad
Bisecting: 103 revisions left to test after this
D       include/asm-blackfin/macros.h
M       scripts/package/Makefile
D       scripts/package/builddeb
[de7f928ca460005086a8296be07c217aac4b625d] Merge master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6
hikaru:/usr/src/kernel/git/linux-2.6>git bisect bad
Bisecting: 98 revisions left to test after this
D       include/asm-blackfin/macros.h
M       scripts/package/Makefile
D       scripts/package/builddeb
[d1be0a8225f2cb1cdc356ebb0ae6800f023ce67d] ide-scsi: fix OOPS in idescsi_expiry()
hikaru:/usr/src/kernel/git/linux-2.6>git bisect bad
Bisecting: 97 revisions left to test after this
D       include/asm-blackfin/macros.h
M       scripts/package/Makefile
D       scripts/package/builddeb
[ce9b2b0abbf019d5259eb089a1cc256852930f67] Resume from RAM on HPC nx6325 broken
hikaru:/usr/src/kernel/git/linux-2.6>git bisect bad
Bisecting: 96 revisions left to test after this
D       include/asm-blackfin/macros.h
M       scripts/package/Makefile
D       scripts/package/builddeb
[d09c6b809432668371b5de9102f4f9aa6a7c79cc] mm: Fix memory/cpu hotplug section mismatch and oops.
hikaru:/usr/src/kernel/git/linux-2.6>git bisect bad
d09c6b809432668371b5de9102f4f9aa6a7c79cc is first bad commit
commit d09c6b809432668371b5de9102f4f9aa6a7c79cc
Author: Paul Mundt <lethal@linux-sh.org>
Date:   Thu Jun 14 15:13:16 2007 +0900

    mm: Fix memory/cpu hotplug section mismatch and oops.

    When building with memory hotplug enabled and cpu hotplug disabled, we
    end up with the following section mismatch:

    WARNING: mm/built-in.o(.text+0x4e58): Section mismatch: reference to
    .init.text: (between 'free_area_init_node' and '__build_all_zonelists')

    This happens as a result of:

            -> free_area_init_node()
              -> free_area_init_core()
                -> zone_pcp_init() <-- all __meminit up to this point
                  -> zone_batchsize() <-- marked as __cpuinit                     fo

    This happens because CONFIG_HOTPLUG_CPU=n sets __cpuinit to __init, but
    CONFIG_MEMORY_HOTPLUG=y unsets __meminit.

    Changing zone_batchsize() to __devinit fixes this.

    __devinit is the only thing that is common between CONFIG_HOTPLUG_CPU=y and
    CONFIG_MEMORY_HOTPLUG=y. In the long run, perhaps this should be moved to
    another section identifier completely. Without this, memory hot-add
    of offline nodes (via hotadd_new_pgdat()) will oops if CPU hotplug is
    not also enabled.

    Signed-off-by: Paul Mundt <lethal@linux-sh.org>
    Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

    --

     mm/page_alloc.c |    2 +-
     1 file changed, 1 insertion(+), 1 deletion(-)

:040000 040000 230b105fa4d9eb2ed873cca8e9ec1b5502ffce79 37636618f4eb88827ec1e524ebb3ac37e44e90f1 M      mm

and (useless, on top of the above, now I see it):

hikaru:/usr/src/kernel/git/linux-2.6>git bisect log
git-bisect start
# bad: [aec07c7abc280bd5d0ca33b7cda3eb7b9b6e89c1] Linux 2.6.22-rc5
git-bisect bad aec07c7abc280bd5d0ca33b7cda3eb7b9b6e89c1
# good: [99f9f3d49cbc7d944476f6fde53a77ec789ab2aa] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband
git-bisect good 99f9f3d49cbc7d944476f6fde53a77ec789ab2aa
# good: [cf68676222e54cd0a31efd968da00e65f9a0963f] Blackfin serial driver: actually implement the break_ctl() function
git-bisect good cf68676222e54cd0a31efd968da00e65f9a0963f
# bad: [3e903e7b1605aff88d7f89a96fab5e43081b914f] cpuset: zero malloc - fix for old cpusets
git-bisect bad 3e903e7b1605aff88d7f89a96fab5e43081b914f
# bad: [de7f928ca460005086a8296be07c217aac4b625d] Merge master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6
git-bisect bad de7f928ca460005086a8296be07c217aac4b625d
# bad: [d1be0a8225f2cb1cdc356ebb0ae6800f023ce67d] ide-scsi: fix OOPS in idescsi_expiry()
git-bisect bad d1be0a8225f2cb1cdc356ebb0ae6800f023ce67d
# bad: [ce9b2b0abbf019d5259eb089a1cc256852930f67] Resume from RAM on HPC nx6325 broken
git-bisect bad ce9b2b0abbf019d5259eb089a1cc256852930f67
# bad: [d09c6b809432668371b5de9102f4f9aa6a7c79cc] mm: Fix memory/cpu hotplug section mismatch and oops.
git-bisect bad d09c6b809432668371b5de9102f4f9aa6a7c79cc

-- 
Carlo Wood <carlo@alinoe.com>
