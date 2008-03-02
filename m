Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbYCBHwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbYCBHwa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 02:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbYCBHwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 02:52:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:50335 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYCBHwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 02:52:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=dEKIXLfXDpw5ksAFW4WZDcGTvvAmkBUiN7UeuMcldLxN4tjcVtFHfHTbcviHAVUgujYLv3o2QyWACZMkA7QTiCWPzue4D9tS9xbJbAYS0fYUjXvXMRWt2qHgRbCSzZ2FPluxNyoCliV20VkVDkJCa58X46m7k8jGiMDerG0tcQQ=
Date: Sun, 2 Mar 2008 09:49:12 +0200
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Adrian Bunk <bunk@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, Alexey Dobriyan <adobriyan@sw.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Anrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v2 -mm] LSM: Add security= boot parameter
Message-ID: <20080302074912.GA3215@ubuntu>
References: <20080301211108.GF25835@cs181133002.pp.htv.fi> <674864.46980.qm@web36615.mail.mud.yahoo.com> <20080301232708.GA625@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301232708.GA625@ubuntu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2008 at 01:27:08AM +0200, Ahmed S. Darwish wrote:
> Hi!,
> 
... 
> LSM modules must check now if they are allowed to register
> by calling security_module_enable(ops) first. Modify SELinux 
> and SMACK to do so.
> 
...
>  
> +/* Boot-time LSM user choice */
> +static char chosen_lsm[SECURITY_NAME_MAX + 1];
> +static atomic_t security_ops_registered = ATOMIC_INIT(0);
>  
...
> +int security_module_enable(struct security_operations *ops)
> +{
> +	if (!ops || !ops->name)
> +		return 0;
> +
> +	if (!*chosen_lsm && !atomic_read(&security_ops_registered))
> +		return 1;
> +
...
> @@ -90,6 +134,7 @@ int register_security(struct security_operations *ops)
>  		return -EAGAIN;
>  
>  	security_ops = ops;
> +	atomic_inc(&security_ops_registered);
>  

I'm worried about an implementation detail here. Must the LSM
init calls sequence:
asmlinkage void __init start_kernel(void)
{
	preempt_disable();
	...
	security_init();
	...

int __init security_init(void)
{
	...
	do_security_initcalls();
}
static void __init do_security_initcalls(void)
{
	initcall_t *call;
	call = __security_initcall_start;
	while (call < __security_initcall_end) {
		(*call) ();
		call++;
	}
}
be SMP safe ?

In other words, can the two LSMs 'security_initcall()'s 
(i.e. smack_init() and selinux_init()) be executed concurrently ?

If so, this patch won't be safe.
I'll send a modified one once I know the answer.

Thanks everybody,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

