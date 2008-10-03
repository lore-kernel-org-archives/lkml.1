Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbYJCOoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbYJCOoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYJCOoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:44:46 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:18132 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbYJCOop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:44:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=bSJNhVAGnM8or/YlmcfuFJK2Kq3z+sjcD31unoYObq8WJ5CloQcP5CylZ6eMht0RAO
         BqDj9wxzJoyzFSyKNTPtz3i6BZcsnzH70b6o2kyVtqdcUwauiLeq1zyR7FqijwrbsuIa
         O+l/XTS6t07ytCD2j0X1w30DWGaZxRvtNhGLg=
Message-ID: <7c86c4470810030744m3bf79e96ud6b387ba3cb5c484@mail.gmail.com>
Date: Fri, 3 Oct 2008 16:44:41 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: perfmon3 interface overview
Cc: linux-kernel@vger.kernel.org, "David Gibson" <david@gibson.dropbear.id.au>
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

Based on the comments from David Gibson, here is another version of
the v3.0 API. This one
collapses the system calls to the maximum while still providing a lot
of flexbility. We are down
to  5 system calls from 12. Of course, each syscall has more of an
ioctl()-style to it but types of
actions are still well separated.

I) session creation

  With v2.81:
    int pfm_create_context(pfarg_ctx_t *ctx,
                           char *smpl_name,
                           void *smpl_arg,
                           size_t smpl_size);
 With v3.0:
    int pfm_create_session(int flags, pfarg_sinfo_t *sif);

    int pfm_create_session(int flags, pfarg_sinfo_t *sif,
                           char *smpl_name,
                           void *smpl_arg,
                           size_t smpl_size);

    Flags:
        PFM_FL_SMPL_FMT    : using sampling format (3 extra params passed)
        PFM_FL_SYSTEM_WIDE : create a system-wide (cpu-wide) session
        PFM_FL_OVFL_NO_MSG  : do not send overflow message (just signal)

    typedef {
        __u64 sif_avail_pmcs[PFM_PMC_BV];/* out: available PMCs */
        __u64 sif_avail_pmds[PFM_PMD_BV];/* out: available PMDs */
        __u64 sif_reserved1[4];          /* for future use */
    } pfarg_sinfo_t;

    The sinfo structure is systematically returned. It contains bitmasks
    showing which registers are available to the session. The PMU may be
    shared with other subsystems, so tools cannot assume they have access
    to all registers. Furthermore, some registers may not be available to
    both types of sessions (per-thread, system-wide).

    If PFM_FL_SMPL_FMT is present, then the kernel expects the extra 3
    paramters to describe which kernel sampling format to use, and its
    optional parameters.

 II) programming the registers

 With v2.81:
      int pfm_write_pmcs(int fd, pfarg_pmc_t *pmds, int  n);
      int pfm_write_pmds(int fd, pfarg_pmd_t *pmcs, int n);
      int pfm_read_pmds(int fd, parg_pmd_t *pmds, int n);
 With v3.0:
      int pfm_write_pmrs(int fd, int flags, void *pmrs, size_t sz);
      int pfm_read_pmrs(int fd, int flags, void **pmrs, size_t sz);

 New structures:

   typedef struct {
       u16 reg_num;
       u16 reg_set;
       u32 reg_flags;
       u64 reg_value;
   } pfarg_pmr_t;

   typedef struct {
       u16 reg_num;
       u16 reg_set;
       u32 reg_flags;
       u64 reg_value;
       u64 reg_long_reset;
       u64 reg_short_reset;
       u64 reg_random_mask;
       u64 reg_smpl_pmds[PFM_PMD_BV];
       u64 reg_reset_pmds[PFM_PMD_BV];
       u64 reg_ovfl_swcnt;
       u64 reg_smpl_eventid;
       u64 reg_last_value;
       u64 reg_reserved[8];
   } pfarg_pmd_attr_t;

 New flags:
    PFM_RWFL_PMD  : passing simplified PMD registers in pfarg_pmr_t
    PFM_RWFL_PMC  : passing PMD registers in pfarg_pmr_t
    PFM_RWFL_PMD_ATTR: passing full PMD registers in pfarg_pmd_attr_t

 We now use only 2 system calls to read and write the PMU registers.

 The vector is now void *. That gives us the ability to pass new types
 of structure in the future if we have to. Also we now use size instead
 of count.

 The calls provides two modes for passing PMD registers. A simplified mode
 used mostly for counting where no attributes are passed. A full mode, where
 extended attributes are passed for kernel-level sampling and multiplexing.
 That way, counting sessions do not pay the price of copying in/out the
 large set of attributes.

  There is only one mode to pass PMC registers.

III) attaching/detaching, starting/stopping

  With v2.81:
     int pfm_load_context(int fd, pfarg_load_t *load);
     int pfm_unload_context(int fd);
     int pfm_start(int fd, pfarg_start_t *st);
     int pfm_stop(int fd);
     int pfm_restart(int fd);

  With v3.0:
     int pfm_control_session(int fd, int flags, int target);

     New flags:
       PFM_CTFL_START: start monitoring
       PFM_CTFL_STOP : stop monitoring
       PFM_CTFL_RESTART: resume monitoring after a notification
       PFM_CTFL_ATTACH: attach to thread or CPU designated by 'target'
       PFM_CTFL_DETACH: detach from thread or CPU (target not used)

   This is a combined syscall, because all those operations have something
   in common, they control the state of the session.


  V) event set and multiplexing
     With v2.81:
        int pfm_create_evtsets(int fd, pfarg_setdesc_t *s, int n);
        int pfm_getinfo_evtsets(int fd, pfarg_setinfo_t *s, int n);
        int pfm_delete_evtsets(int fd, pfarg_setdesc_t *s, int n);

    With v3.0:
        int pfm_control_sets(int fd, int flags, void *s, size_t sz;

        typedef struct {
        __u16 set_id;             /* which set */
        __u16 set_reserved1;      /* for future use */
        __u32 set_flags;          /* SETFL flags  */
        __u64 set_timeout;        /* switch timeout in nsecs */
        __u64 reserved[6];        /* for future use */
        } pfarg_set_desc;

        typedef struct {
        __u16 set_id;                   /* which set */
        __u16 set_reserved1;            /* for future use */
        __u32 set_reserved2;            /* for future use */
        __u64 set_ovfl_pmds[PFM_PMD_BV];/* out: last ovfl PMDs */
        __u64 set_runs;         /* out: #times the set was active */
        __u64 set_timeout;      /* out: leftover timeout (nsecs) */
        __u64 set_duration;     /* out: time set was active in nsecs */
        __u64 set_reserved3[4]; /* for future use */
        } pfarg_set_info;

    New flags:
      PFM_STFL_CREAT : create new event sets using pfarg_set_desc_t
      PFM_STFL_INFO  : get info about event sets using pfarg_set_info_t


   Here again we combine syscall because they all control events sets.
   The pfm_delete_evtsets() has no equivalent, but it could easily be added
   if we have a strong need for it.


Any opinions on this revised v3.0 interface?

Thanks
