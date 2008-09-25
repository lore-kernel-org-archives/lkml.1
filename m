Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbYIYVsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbYIYVsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYIYVsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:48:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:47445 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYIYVsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:48:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=V3bcNg7J6X8duOKh3XGhrXmYtkYAF7tPKFGsSF85jYZY20KiyG6nmaIxXDcfzvIClM
         eZhLAXFNJTyy+XuTGGXlzATN1SMONM0DwWFcEaysaI7GGSxBDtYI5QJdkU38uy5hvK/j
         5LduIexMQEEf4f7OO528Xn3p86gbOVJQcS+Iw=
Message-ID: <7c86c4470809251448j65fb99f1nfdb3980e0716149a@mail.gmail.com>
Date: Thu, 25 Sep 2008 23:48:27 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: linux-kernel@vger.kernel.org
Subject: perfmon3 interface overview
In-Reply-To: <7c86c4470809231432j4231cfa4g7dd158a7fe9c9277@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470809231432j4231cfa4g7dd158a7fe9c9277@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

A few months ago, I started posting on this list a highly simplified version
of the perfmon2 version which was providing only per-thread counting on X86
processors.

The feedback I got was generally positive but people raised two more issues:

    - too many system calls for a single subsystem (12 calls)

    - how to ensure syscalls could be extended without necessarily
      adding new ones.


Since then, I have been working hard on addressing those two issues, in other
words redesign of the perfmon2 syscall API. This message is to announce that I
now have a new proposal for the API. As expected it is called perfmon3 and
it addresses the two issues above while allowing backward compatibility with the
existing v2.81 version through a user level glue layer which could be
implemented
by a library such as libpfm.


The new API now has 8 system calls in its fully-featured version. Many
data structures
shared with user level have been abandoned in favor of explicit
syscall parameters.
Each syscall has a flags parameters which allows the syscalls to be
extended with
new parameters when we need them. Most structures passed to the kernel have
reserved fields for future extensions.

The initial patchset will only support per-thread counting as I did
previously. However,
here I am presenting the details for the fully featured version so
people can get a feel
for it. For each call I show the old way and the new way.

Note that when the syscall is shown twice with a different number of
parameters, this
variation is handled by the user library. The kernel implements the
full call. This is
the same technique used for the open(2) syscall.

 I) session creation

 With v2.81:
    int pfm_create_context(pfarg_ctx_t *ctx, char *smpl_name, void
                                          *smpl_arg, size_t smpl_size);

 With v3.0:
    int pfm_create_session(int flags);
    int pfm_create_session(int flags, char *smpl_name,
                                          void *smpl_arg, size_t smpl_size);

    New Flags:
         PFM_FL_SMPL_FMT : indicate using sampling format and
                                               that 3 additional
parameters are passed

 The pfarg_ctx_t structure has been abandoned. The flags parameter is
 used very much like for the open(2) syscall to indicate that additional
 (optional) parameters are passed.

  All v2.81 flags are preserved.

  The call still returns the file descriptor uniquely identifying the session.

  Just like with context, a session can either be monitoring a thread or a CPU.

 II) programming the registers

 With v2.81:
      int pfm_write_pmcs(int fd, pfarg_pmc_t *pmds, int  n);
      int pfm_write_pmds(int fd, pfarg_pmd_t *pmcs, int n);
      int pfm_read_pmds(int fd, parg_pmd_t *pmds, int n);

 With v3.0:
      int pfm_write_pmrs(int fd, int flags, pfarg_pmr_t *pmrs, int n);
      int pfm_write_pmrs(int fd, int flags, pfarg_pmr_t *pmrs, int n,
                                      pfarg_pmd_attr_t *pmas);

      int pfm_read_pmrs(int fd, int flags, pfarg_pmr_t *pmrs, int n);
      int pfm_read_pmrs(int fd, int flags, parg_pmr_t *pmrs, int n,
                                     pfarg_pmd_attr_t *pmas);

 New structures:

   typedef struct {
       u16 reg_num;
       u16 reg_set;
       u32 reg_flags;
       u64 reg_value;
   } pfarg_pmr_t;

   typedef struct {
       u64 reg_long_reset;
       u64 reg_short_reset;
       u64 reg_random_mask;
       u64 reg_smpl_pmds[PFM_PMD_BV];
       u64 reg_reset_pmds[PFM_PMD_BV];
       u64 reg_ovfl_swcnt;
       u64 reg_smpl_eventid;
       u64 reg_last_value;
       u64 reg_reserved[8];
   } pfarg_pmd_t;

 New flags:
    PFM_RWFL_PMD  : pmrs contains PMD register descriptions
    PFM_RWFL_PMC  : pmrs contains PMC register descriptions
    PFM_RWFL_PMD_ATTR: PFM_RWFL_PMD + attributes

 We now use only 2 system calls to read and write the PMU registers.
 This is possible because we are sharing the same register description
 data structure, pfarg_pmr_t. They key attributes of each register are
 encapsulated into this structure. Additional PMD attributes related to
 sampling and multiplexing are off-loaded into another optional structure,
 pfarg_pmd_attr_t. This structure becomes optional and is only looked at
 by the kernel if the PFM_RWFL_PMD_ATTR flag is passed.

 For all counting applications, using pfarg_pmr_t is enough. The nice
 side effect of this split is that the cost of reading and writing PMD register
 is now reduced because we have less data to copy in and out of the kernel.

 Unlike suggested by some people, I have not merged the notions of
 PMD and PMC registers. I think it is cleaner to separate them out. It
 also makes it much easier to provide backward compatibility with v2.81.

III) attaching and detaching

  With v2.81:
     int pfm_load_context(int fd, pfarg_load_t *load);
     int pfm_unload_context(int fd);

  With v3.0:
     int pfm_attach_session(int fd, int flags, int target);
     int pfm_detach_session(int fd, int flags);

  The pfarg_load_t structure has been abandoned. The information about what
  to attach to is passed as a parameter to the syscall in "target". It
can either be
  a thread id or a CPU id.

  There are currently no flags defined for either call.

   Note that we have lost the ability to specify which event set is
   to be activated first. There was no actual use of this option anyway.

   Some people have suggested that I use 'unsigned long' instead of 'int'
   for target. I am not against it.

 IV) starting and stopping

   With v2.81:
      int pfm_start(int fd, pfarg_start_t *st);
      int pfm_stop(int fd);
      int pfm_restart(int fd);

   With v3.0:
      int pfm_start_session(int fd, int flags);
      int pfm_stop_session(int fd, int flags);

     New flags:
     PFM_STFL_RESTART: resume monitoring after an overflow notification

     The pfarg_start_t structure has been abandoned.

     The pfm_restart() syscall has been merged with pfm_start() by
     using the PFM_STFL_RESTART  flag. It is not possible to just
     use pfm_start_session() and internally determine what to do
     because this is dependent on the sampling format.

      We have lost the ability to specify on which event set to
      start. I don't think this option was ever used.

  V) event set and multiplexing

     With v2.81:
        int pfm_create_evtsets(int fd, pfarg_setdesc_t *s, int n);
        int pfm_getinfo_evtsets(int fd, pfarg_setinfo_t *s, int n);
        int pfm_delete_evtsets(int fd, pfarg_setdesc_t *s, int n);

    With v3.0:
        int pfm_create_sets(int fd, int flags, pfarg_setdesc_t *s, int n);
        int pfm_getinfo_sets(int fd, int flags, pfarg_setinfo_t *s, int n);

    We have kept the same data structures and simply added a flags
    parameters to provide for extensibility of the calls.

    We have removed pfm_delete_evtsets() because it was not used by
    a lot of applications. We could add it back later if there is a good reason
    for it , something stronger than saying it needs to be there for symmetry.


The code for v3.0 has been uploaded into the perfmon GIT tree at kernel.org.
 It is located in the perfmon3 branch.

I am hoping this will lift the last remaining issues and we will be
able to  start
merging perfmon3 into mainline.

Thanks.
