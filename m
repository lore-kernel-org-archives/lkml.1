Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYE1J7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYE1J7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 05:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYE1J7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 05:59:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38863 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751722AbYE1J73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 05:59:29 -0400
Date: Wed, 28 May 2008 04:59:22 -0500
From: Paul Jackson <pj@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: ying.huang@intel.com, akpm@linux-foundation.org, tglx@linutronix.de,
       steiner@sgi.com, travis@sgi.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, mingo@elte.hu
Subject: Re: [PATCH 10/10] x86 boot: add code to add BIOS provided EFI
 memory entries to kernel
Message-Id: <20080528045922.38c4b196.pj@sgi.com>
In-Reply-To: <483C5DF4.60508@zytor.com>
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
	<20080514151558.148486.91282.sendpatchset@jackhammer.engr.sgi.com>
	<1211857948.12819.84.camel@caritas-dev.intel.com>
	<20080527140848.ce57845b.pj@sgi.com>
	<483C5DF4.60508@zytor.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> This was discussed over a year ago, and it was declared the boot
> loaders' responsibility.  Please go back and look at the archives for
> the discussion rather than rehashing it at this time.


Good grief - you're right.  I had only looked back nine months in my
archives, as you can tell, from my last message, in which I recite
some of that history.  This saga has dragged on for two years now.

Summary of what's transpired in the last two years:

  A] In the summer of 2006, Edgar Hucek submitted a patch that
     after some back and forth ended up doing pretty much what my
     latest patch does -- enabling the kernel to extract any EFI
     memory map entries and add them to the E820 map.
     
     At the time, there seemed to be agreement from both Linus and
     yourself (hpa) that this was a good approach.
     
     However, Edgar Hucek, perhaps not used to the various details
     and difficulties needed to gain acceptance of a kernel patch,
     gave up and went away before the patch gained final acceptance.

  B] Beginning in May of 2007, with the work of Chandramouli
     "Mouli" Narayanan, and continuing in July 2007 with the
     work of Ying Huang, when Mouli went on sabbatical, an
     extended series of patches has added EFI support to x86_32
     and x86_64.

  C] Beginning in August 2007, H. Peter Anvin has been advocating
     that instead of the approach of [A] above, rather we extend the
     e820 interface between the bootloader and the kernel to pass
     more than a single 4K page (the legacy 'zeropage'), using a
     linked of setup_data structs.
     
     Ying Huang has been fully supportive of this direction,  and,
     along with the reserve_memory() apparatus by Andi Kleen,
     providing the bulk of the code implementing it.
     
     The essential motivation for this extension of the e820 interface
     seems to be allowing for more than six drives in the EDD BIOS
     Enhanced Disk Drive Services interface.

  D] Beginning in January 2008, I have been repeatedly urging
     the portion of this work along that would enable more
     memory nodes than the 128 (E820MAX) allowed by the legacy
     e820 bios interface.  It is essential for my current
     project.  We really wanted this in 2.6.26, but no later
     than 2.6.27.

  E] Now, in May 2008, I present a patch set, the key part of
     which is a rather simple code loop, to copy any EFI memory
     map entries over to the E820 memory map.
     
     Earlier patches in this set generalize some data types (such
     as a u8 array index) and some array sizes (from the hard coded
     E820MAX) in order to accomodate E820 memory map structures
     internal to the kernel that are larger than what might be passed
     by the legacy interface.  I suspect that these patches growing
     the kernels internal e820 memory map will be needed by the
     extended setup_data linked list e820 interface that Peter
     and Ying have been working toward, for nine months now.

I have detailed this history further below, as a by-product of my
reviewing it myself, to be sure I fully went "back and looked at the
archives", as Peter requested.


Conclusions:
------------

  As I stated in my reply to Ying to which you are responding, Peter,
  my patch does not preclude you and Ying from continuing toward your
  goal of nine months now to extend the e820 interface to handle a
  linked list of setup_data structs.
  
  Indeed, much of my patch set is stuff you'll need anyway, to enable
  growing the internal kernel e820 map structures to more than 128
  entries.
  
  There is just a single patch, containing one new routine of less
  than 20 straight forward lines of code, that is at issue here.
  That routine copies efi memory entries into the e820 map.

  As Linus, and yourself, noted some two years ago, such copying of the
  efi map entries to the e820 map is a simple and sensible approach.
  
  I've waited, patiently proddding now for five months, and it has
  been nine months since you proposed the linked list of setup_data,
  and still it is not entirely coded or in the tree.  It missed
  2.6.26, and looks not to make 2.6.27 either.
  
  I can wait no longer; I do not stand in your way; and I only ask for
  this one small, sensible, alternative to handling larger memory maps.
  
  The two of you, Ying and Peter, are welcome to continue work with
  your planned extension to the e820 interface.  I appreciate that
  you need it for additional EDD entries, and that some, even most,
  BIOS's may prefer to use it for additional memory map entries.

  That's fine.  But, as has been long understood, it is not the only
  possible solution for additional memory map entries on EFI systems.

  Meanwhile, and in any case, my special thanks to Ying Huang for
  his substantial and extended work in adding EFI support to
  x86_64.  His work is much appreciated and vital to the project
  on which I'm focused.  Thanks, Ying!


===

Ok ... rolling back the hands of time (those who are not
terminally masochistic can stop reading now ;).


==================== June - August 2006 ====================

1) On June 20 to 28, 2006, Edgar Hucek posted a series of patches:
   	[PATCH 1/1] Fix boot on efi 32 bit Machines
   This patch set bypassed the failing e820 code memory map
   loading code on systems, such as Intel Mac's, that had no
   E820 memory map.

2) On June 27, 2006, Linus wrote in the discussion of Edgar's patches:

      I'd really suggest just filling in the e820 table from the
      EFI information early at boot.

      (Even better would be for the EFI bootloader on x86 to just
      fill things in _as_if_ it was filling in e820 data, but that's
      outside of the kernel, so if you want the _kernel_ to be able
      to handle native EFI data, do it by just translating it once
      into e820 mode, and you're done).

      The translation from EFI to e820 format should be very
      straightforward indeed. I think it's pretty much the same
      thing with different naming.

3) On June 28, 2006, hpa (you might know him ;) replied to Linus:

      You probably don't want to put it in the bootloader.  The kernel
      is easier to upgrade than the bootloader, which is easier to
      upgrade than the firmware, so it makes more sense for the kernel
      to be as self-sufficient as is possible, or at least practical.

4) On July 2, 2006, Eric W. Biederman replied to the above discussion
   of Hucek's above patches with a request to remove or disable the
   efi implementation hacks, because they break kexec, at least if
   EFI callbacks are used.  (Sorry, Eric, if I misstated that one.)

5) July 2-14, 2006, the discussion of the above patch continued,
   with increasing evidence of problems with the kernels EFI code.

6) On July 16, 2006, Edgar Hucek posted the patch:
       [PATCH 1/1] Add efi e820 memory mapping on x86 [try #1]
   This patch added efi memory entries to the e820 map if efi was
   enabled at boot.  I should study this patch more closely; it might
   have details that I should pick up for my current patch proposal.

7) On July 24, 2006, Eric W. Biederman justified this latest patch
   of Edgar Hucek by stating:

      The x86 architecture needs a way to represent the firmware
      supplied memory map in a way that later code can query what is
      in the map.  The easiest way to do this is simply to convert
      the efi memory map into an e820 memory map.

8) On July 24, 2006, Linus stated that "Edgars patch looks fine per se",
   though Linus wished for more testers.  Linus also took the occassion
   to criticize EFI and ACPI.  H. Peter Anvin reminded Linus that
   PXE was also worthy of criticism.  Linus said he wasn't forgetting
   PXE; rather he was just repressing it.

10) On July 26, 2006, Andrew Morton accepted Edgars patch into
    2.6.18-rc4-mm1.  Various fixes and minor confusions followed.

11) Edgar Hucek's last post, ever, to lkml made on August 19, 2006.

12) On August 21, 2006, Andrew dropped Edgars patch, because:
       "it got rejects, and I don't think we'll be proceeding with it anwyay?"
    I cannot find the discussion that led to Andrew thinking that
    we were not proceeding with this patch.


==================== May - Dec 2007 ====================

13) On May 1, 2007,  Chandramouli "Mouli" Narayanan submitted a patch set
   "x86_64: EFI64 support" to add EFI support to x86_64.

14) Various comments to these patches, including Andi Kleen's comment:
        "Please convert the memory map from EFI into the e820 map in one place."

15) On July 2, 2007, Mouli submitted second version of this patch set,
    with numerous improvements, including:

       - Implemented EFI to E820 memory map conversion. This is based on
         bootloader support. The ELILO bootloader x86_64 support has been
         updated to pass E820 map to kernel.

16) On July 4, 2007, Ying Huang picked up this task from Mouli, who
    left for sabbatical.

17) On July 31, 2007, Ying Huang submitted another update of the patches
    to add EFI support to x86_64.  Various comments, especially from
    Andi Kleen and Eric W. Biederman.

18) On August 9, 2007, Ying Huang submitted another update.  The EFI
    memory map is converted to E820 in the bootloader, so kernel
    support is not needed to parse an EFI memory map.

19) On August 9, 2007, H. Peter Anvin proposes a "linked list of tagged
    data items" to extend the boot protocol past the compromises imposed
    by a 4K boot page (zeropage):

	I mentioned in private email to a few people that I think
	a linked list of tagged data items (similar to the way PCI
	capabilities work) would probably make sense; we want a piece
	of code to know the structure without needing to know the
	contents, in order to rescue data.
    
20) August 13-22, 2007 has a lengthy discussion between Ying, Peter,
    and Andi, in a thread with the Subject of:
        "[PATCH 0/3] x86_64 EFI runtime service support"
    This discussion is likely part of what Peter refers to as "over a
    year ago" (only nine months, actually.)

21) Another patchset from Ying on August 13, 2007.

22) This version of the patch set had a "major trainwreck" (to quote
    Andrew) with Peter's git-newsetup.patch, and so got dropped on
    August 15, 2007.

23) On Sept 17, 2007, Ying Huang presents a patchset with a new 32 bit
    boot protocol for use on non-legacy i386 and for x86_64, with an
    extensible linked list of boot parameters.  A recognized issue was
    finding a safe place for this linked list of setup_data.

24) On Sept 18, 2007, Ying Huang updated this patchset (setup_data
    linked list 32 bit boot protocol) (patch version v2)

25) On Sept 19, 2007, patch version v3 from Ying Huang.

26) On Sept 22, 2007, in response to a question of "why?" from Jeremy
    Fitzhardinge, H. Peter Anvin explained that the linked list was
    needed because:

	We have already run into at least one case where the existing
	structure is insufficient (EDD overhaul), and so we need to
	do something extensible.

27) On October 9, 2007, patch version v4 from Ying Huang.

28) On October 12, 2007, patch version v5 from Ying Huang.

29) On October 16, 2007, patch from H. Peter Anvin replaces the
    "magic macros" with a boot_params structure.
    
30) On October 22, 2007, patch version v6 from Ying Huang.

31) On October 23, 2007, Ying Huang submitted the documentation of
    the 32 bit x86 boot protocol as a separate patch, documenting
    current behaviour.

32) On October 24, 2007, Ying Huang resent his x86_64 EFI boot support
    patches, asking Andrew Morton to accept them into *-mm, which
    Andrew did.

33) On October 25, 2007, Ying Huang submitted a 4 patch set for
    x86_64 EFI runtime service support (version v4).  Continued
    discussion of whether EFI runtime services were needed, with
    Ying Huang concluding that at least the BIOS variable service
    was useful, and that it didn't break anything, but that it
    should be via virtual mode (to improve reliability of OOPS
    information writing) and that some code duplication between
    efi_32.c and efi_64.c needed to be eliminated.
    
34) On October 30, 2007, Ying Huang released version v5 of his
    x86_64 EFI runtime service support patches.

35) On Nov 2, 2007, Ying Huang submitted version v3 of his x86_64 boot
    support patches.

36) On Nov 5, 2007, Andrew Morton added v3 of the x86_64 EFI boot
    support for EFI frame buffer to *-mm, and it was included in
    2.6.24.  However the linked list setup_data patches were not
    included, due to ongoing discussions over how to reserve early
    memory for them.

37) On Nov 26 to Dec 14, Ying Huang updated his x86_64 EFI runtime
    service patches.  Sometime thereafter they seem to have made
    their way into the mainline kernel.

38) On Dec 11, 2007, Ying Huang removed some code that had been
    handling the EFI memory map, because it is "converted to e820
    memory map in bootloader."

39) On Dec 29, 2007, Ying Huang submitted patch to split EFI
    table parsing from EFI runtime support.


==================== Jan - May 2008 ====================

40) January, 2008, various refinements and fixes from Ying Huang.

41) January 18 and 23, 2008 - I (pj) begin asking when and how
    the 128 memory map limit (E820MAX) will be overcome.
    
42) February 12 and 14, 2008, various EFI cache mapping bug fixes
    from Andi Kleen.

43) February 20, 2008, I (pj) renewed my inquiry as to when x86_64
    EFI extensions for high node counts would be available.  I was
    looking for them to be merged by 2.6.26.

44) Andi Kleen, in one reply to my inquiry, wrote:

      Anyways if it's really a problem I guess the easiest fix would be
      to just call EFI again and get the true map directly and convert
      it to e820. As long as it's only in a single place somewhere
      in the EFI code and not spread all over that should be fine.

   [P.S. - it is a real problem, we missed 2.6.26, and still don't
   have a firm release date, and my latest patch set of last week
   does as Andi suggests, which looks to be what Linus and (in an
   earlier life, Peter) thought sensible, in response to Edgar Hucek's
   patches of 2006. -pj]

   H. Peter Anvin replied to Andi with:
   
       We need the expanded boot protocol *anyway*, for other reasons.
     
   In reply to Andi asking what these other reasons were, Peter wrote:
   
       So far, we have at least EDD, which is currently truncated to the
       point of uselessness (see posts by Alan Cox for the gory details),
       and non-EFI systems.

45) In a discussion on March 3 and 4 of these early memory needs
    for both 32 and 64 bit systems, Ingo Molnar noted:
    
	i'd strongly support the moving of this from the realm
	of talk into the realm of code! :-)

46) The above February discussion died out, so on March 23, 2008,
    I asked again "how goes this work?"
    
    The answer turned out to be that it was awaiting a x86_32 version
    of the reserve_early() memory allocation handler of Andi Kleen.

47) On May 14, 2008, I (pj) submitted a patchset that extracted
    any EFI memory map and added it to the e820 map.

    Ingo added this to his x86 tree.

48) On May 27, 2008, Ying Huang responded to my patchset, stating he
    preferred the planned extensions to the E820 boot protocol
    (the linked list of setup_data allowing more than one page
    of boot information to be passed.)

49) On May 27, 2008, I replied to Ying Huang, explaining advantages
    of my patches, and noting that they do -not- conflict with
    his planned  extensions to the E820 boot protocol.

50) On May 27, 2008, H. Peter Anvin replied to me, asking me not to
    rehash a discussion of "over a year ago."

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
