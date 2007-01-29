Return-Path: <linux-kernel-owner+w=401wt.eu-S1751365AbXA2NIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbXA2NIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 08:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbXA2NIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 08:08:25 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:52341 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751365AbXA2NIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 08:08:24 -0500
Subject: Re: [PATCH] sysctl selinux: Don't look at table->de
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       jmorris@namei.org, Eric Paris <eparis@parisplace.org>
In-Reply-To: <m1r6tfq7nv.fsf_-_@ebiederm.dsl.xmission.com>
References: <200701280106.l0S16CG3019873@shell0.pdx.osdl.net>
	 <20070127172410.2b041952.akpm@osdl.org>
	 <1169972718.17469.164.camel@localhost.localdomain>
	 <20070128003549.2ca38dc8.akpm@osdl.org> <20070128093358.GA2071@elte.hu>
	 <20070128095712.GA6485@elte.hu> <20070128100627.GA8416@elte.hu>
	 <20070128104548.a835d859.akpm@osdl.org>
	 <m1r6tfq7nv.fsf_-_@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 29 Jan 2007 08:04:26 -0500
Message-Id: <1170075866.8720.15.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-01-28 at 12:21 -0700, Eric W. Biederman wrote:
> With the sysctl cleanups sysctl is not really a part of proc
> it just shows up there, and any path based approach will not
> adequately describe the data as sysctl is essentially a
> union mount underneath the covers.  As designed this mechanism
> is viewer dependent so trying to be path based gets even worse.
> 
> However the permissions in sys_sysctl are currently immutable
> and going through proc does not change the permission checks
> when accessing sysctl.  So we might as well stick with the well
> defined sysctl sid, as that is what selinux uses when proc is
> not compiled in.
> 
> I.e.  I see no hope for salvaging the selinux_proc_get_sid call
> in selinux_sysctl so I'm removing it.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  security/selinux/hooks.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 7b38372..3a36057 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1438,12 +1438,8 @@ static int selinux_sysctl(ctl_table *table, int op)
>  
>  	tsec = current->security;
>  
> -	rc = selinux_proc_get_sid(table->de, (op == 001) ?
> -	                          SECCLASS_DIR : SECCLASS_FILE, &tsid);
> -	if (rc) {
> -		/* Default to the well-defined sysctl SID. */
> -		tsid = SECINITSID_SYSCTL;
> -	}
> +	/* Use the well-defined sysctl SID. */
> +	tsid = SECINITSID_SYSCTL;
>  
>  	/* The op values are "defined" in sysctl.c, thereby creating
>  	 * a bad coupling between this module and sysctl.c */

NAK.  Mapping all sysctls to a single security label prevents any kind
of fine-grained security on sysctls, and current policies already make
use of the current distinctions to limit access to particular sets of
sysctls to particular processes.  As is, I'd expect breakage of current
systems running SELinux from this patch, because (confined) processes
that formerly only required access to specific sysctl labels will
suddenly run into denials on the generic fallback label.

If the ctl_table supplied more information about the functional purpose
and the security sensitivity of the sysctl, then we could leverage that
information instead, as long as we can at least derive the current
labelings from that information for compatibility.

-- 
Stephen Smalley
National Security Agency

