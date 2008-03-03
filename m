Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbYCCPic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbYCCPic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 10:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbYCCPiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 10:38:24 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:65084 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbYCCPiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 10:38:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=wCR6a8P4f+kkeC2m7GY1l1lrijeqtkZVMIY4hyVsPyUi68RUsZgoD7aSFkGccTDggwGtL7I1SEvcLIoOXw/1TEviaxfYi+169J5fIhNSaJ8PehnZYXokL0F7//c/u5sIcBKUDQOiVquki9dVZOtgpSOiUsRrdWBcjBlLgPyOoic=
Date: Mon, 3 Mar 2008 17:35:10 +0200
To: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Adrian Bunk <bunk@kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>, Alexey Dobriyan <adobriyan@sw.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Anrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v3 -mm] LSM: Add security= boot parameter
Message-ID: <20080303153510.GA6963@ubuntu>
References: <20080301211108.GF25835@cs181133002.pp.htv.fi> <674864.46980.qm@web36615.mail.mud.yahoo.com> <20080301232708.GA625@ubuntu> <20080302074912.GA3215@ubuntu> <20080302105946.GA6406@ubuntu> <Xine.LNX.4.64.0803031910170.6729@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Xine.LNX.4.64.0803031910170.6729@us.intercode.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Mon, Mar 03, 2008 at 07:29:22PM +1100, James Morris wrote:
> On Sun, 2 Mar 2008, Ahmed S. Darwish wrote:
> 
> > Add the security= boot parameter. This is done to avoid LSM 
> > registration clashes in case of more than one bult-in module.
> > 
> > User can choose a security module to enable at boot. If no 
> > security= boot parameter is specified, only the first LSM 
> > asking for registration will be loaded. An invalid security 
> > module name will be treated as if no module has been chosen.
> > 
> > LSM modules must check now if they are allowed to register
> > by calling security_module_enable(ops) first. Modify SELinux 
> > and SMACK to do so.
> 
> I think this can be simplified by folding the logic into 
> register_security(), rather than having a two-stage LSM registration 
> process.
> 
> So, this function would now look like
> 
> 	int register_security(ops, *status);
> 
> and set *status to LSM_WAS_CHOSEN (or similar) if the module being 
> registered was also chosen via the security= parameter.  If there is no 
> value for the parameter, the first module to register is automatically 
> chosen, to preserve existing behavior.
> 
> The calling code can then decide what to do, e.g. not panic if 
> registration failed and the LSM was not chosen; panic on failure when it 
> was chosen.
> 

I liked to do it like that at first, but I faced two problems:

SElinux (As you already know ;)) does the security setup of the initial 
task before calling register_security. Would it be safe to do this
setup after registeration ?

Same case occurs for Smack, it does some locking initializations and
setup initial task's security before registration.

Personally, I feel that it's nicer to let the LSM know if it's
OK to initialize itself before hitting _the point of no return_ (registration).

Anyway, I have no problem to implement it using *status if my 
concerns are wrong.

> > +static atomic_t security_ops_enabled = ATOMIC_INIT(-1);
> 
> I'd suggest getting rid of this atomic and using a spinlock to protect the 
> global chosen_lsm string, which is always filled when an LSM registers.
> 
> >  
> > +/* Save user chosen LSM */
> > +static int __init choose_lsm(char *str)
> > +{
> > +	strncpy(chosen_lsm, str, SECURITY_NAME_MAX);
> > +	chosen_lsm[SECURITY_NAME_MAX] = NULL;
> 
> You should never need to set the last byte to NULL -- it's initialized to 
> that and by definition should never be overwritten.
> 
> > +int security_module_enable(struct security_operations *ops)
> > +{
> > +	if (!ops || !ops->name)
> > +		return 0;
> 
> Lack of ops->name during registration needs to be a BUG_ON.
> 

You'll find above three points fixed the next send. Thank you.

Regards,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

