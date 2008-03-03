Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbYCCIdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbYCCIdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 03:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYCCIcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 03:32:42 -0500
Received: from namei.org ([69.55.235.186]:54085 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753277AbYCCIci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 03:32:38 -0500
Date: Mon, 3 Mar 2008 19:29:22 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: Casey Schaufler <casey@schaufler-ca.com>, Adrian Bunk <bunk@kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>, Alexey Dobriyan <adobriyan@sw.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Anrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v3 -mm] LSM: Add security= boot parameter
In-Reply-To: <20080302105946.GA6406@ubuntu>
Message-ID: <Xine.LNX.4.64.0803031910170.6729@us.intercode.com.au>
References: <20080301211108.GF25835@cs181133002.pp.htv.fi>
 <674864.46980.qm@web36615.mail.mud.yahoo.com> <20080301232708.GA625@ubuntu>
 <20080302074912.GA3215@ubuntu> <20080302105946.GA6406@ubuntu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Mar 2008, Ahmed S. Darwish wrote:

> Add the security= boot parameter. This is done to avoid LSM 
> registration clashes in case of more than one bult-in module.
> 
> User can choose a security module to enable at boot. If no 
> security= boot parameter is specified, only the first LSM 
> asking for registration will be loaded. An invalid security 
> module name will be treated as if no module has been chosen.
> 
> LSM modules must check now if they are allowed to register
> by calling security_module_enable(ops) first. Modify SELinux 
> and SMACK to do so.

I think this can be simplified by folding the logic into 
register_security(), rather than having a two-stage LSM registration 
process.

So, this function would now look like

	int register_security(ops, *status);

and set *status to LSM_WAS_CHOSEN (or similar) if the module being 
registered was also chosen via the security= parameter.  If there is no 
value for the parameter, the first module to register is automatically 
chosen, to preserve existing behavior.

The calling code can then decide what to do, e.g. not panic if 
registration failed and the LSM was not chosen; panic on failure when it 
was chosen.

> +static atomic_t security_ops_enabled = ATOMIC_INIT(-1);

I'd suggest getting rid of this atomic and using a spinlock to protect the 
global chosen_lsm string, which is always filled when an LSM registers.

>  
> +/* Save user chosen LSM */
> +static int __init choose_lsm(char *str)
> +{
> +	strncpy(chosen_lsm, str, SECURITY_NAME_MAX);
> +	chosen_lsm[SECURITY_NAME_MAX] = NULL;

You should never need to set the last byte to NULL -- it's initialized to 
that and by definition should never be overwritten.

> +int security_module_enable(struct security_operations *ops)
> +{
> +	if (!ops || !ops->name)
> +		return 0;

Lack of ops->name during registration needs to be a BUG_ON.


- James
-- 
James Morris
<jmorris@namei.org>
