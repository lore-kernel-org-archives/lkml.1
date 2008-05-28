Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbYE1IGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbYE1IGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 04:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYE1IGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 04:06:08 -0400
Received: from gw.goop.org ([64.81.55.164]:51841 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbYE1IGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 04:06:05 -0400
Message-ID: <483D1248.8080400@goop.org>
Date: Wed, 28 May 2008 09:05:28 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] call_usermodehelper() increase reliability
References: <20080527212423.9CAD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080527212423.9CAD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Now, call_usermodehelper_setup() uses GFP_ATOMIC.
> but it can return NULL _very_ easily.
>
> GFP_ATOMIC is needed only when we can't sleep.
> and, GFP_KERNEL is robust and better.
>
> thus, I add gfp_mask argument to call_usermodehelper_setup().
>
> So, its caller pass below,
>
> call_usermodehelper() and call_usermodehelper_keys(): 
> 	depend on 'wait' argument.
> call_usermodehelper_pipe():
> 	always GFP_KERNEL because always run under process context.
> orderly_poweroff():
> 	pass to GFP_ATOMIC because may run under interrupt context.
>
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: "Paul Menage" <menage@google.com>
> CC: Li Zefan <lizf@cn.fujitsu.com>
> CC: Jeremy Fitzhardinge <jeremy@xensource.com>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: Andi Kleen <andi@firstfloor.org>
>   

Yes, looks good.

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

> ---
>  include/linux/kmod.h |   11 +++++++----
>  kernel/kmod.c        |    9 +++++----
>  kernel/sys.c         |    2 +-
>  3 files changed, 13 insertions(+), 9 deletions(-)
>
> Index: b/kernel/kmod.c
> ===================================================================
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -352,16 +352,17 @@ static inline void register_pm_notifier_
>   * @path: path to usermode executable
>   * @argv: arg vector for process
>   * @envp: environment for process
> + * @gfp_mask: gfp mask for memory allocation
>   *
>   * Returns either %NULL on allocation failure, or a subprocess_info
>   * structure.  This should be passed to call_usermodehelper_exec to
>   * exec the process and free the structure.
>   */
> -struct subprocess_info *call_usermodehelper_setup(char *path,
> -						  char **argv, char **envp)
> +struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
> +						  char **envp, gfp_t gfp_mask)
>  {
>  	struct subprocess_info *sub_info;
> -	sub_info = kzalloc(sizeof(struct subprocess_info),  GFP_ATOMIC);
> +	sub_info = kzalloc(sizeof(struct subprocess_info), gfp_mask);
>  	if (!sub_info)
>  		goto out;
>  
> @@ -494,7 +495,7 @@ int call_usermodehelper_pipe(char *path,
>  	struct subprocess_info *sub_info;
>  	int ret;
>  
> -	sub_info = call_usermodehelper_setup(path, argv, envp);
> +	sub_info = call_usermodehelper_setup(path, argv, envp, GFP_KERNEL);
>  	if (sub_info == NULL)
>  		return -ENOMEM;
>  
> Index: b/include/linux/kmod.h
> ===================================================================
> --- a/include/linux/kmod.h
> +++ b/include/linux/kmod.h
> @@ -19,6 +19,7 @@
>   *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> +#include <linux/gfp.h>
>  #include <linux/stddef.h>
>  #include <linux/errno.h>
>  #include <linux/compiler.h>
> @@ -40,8 +41,8 @@ struct file;
>  struct subprocess_info;
>  
>  /* Allocate a subprocess_info structure */
> -struct subprocess_info *call_usermodehelper_setup(char *path,
> -						  char **argv, char **envp);
> +struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
> +						  char **envp, gfp_t gfp_mask);
>  
>  /* Set various pieces of state into the subprocess_info structure */
>  void call_usermodehelper_setkeys(struct subprocess_info *info,
> @@ -68,8 +69,9 @@ static inline int
>  call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
>  {
>  	struct subprocess_info *info;
> +	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
>  
> -	info = call_usermodehelper_setup(path, argv, envp);
> +	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
>  	if (info == NULL)
>  		return -ENOMEM;
>  	return call_usermodehelper_exec(info, wait);
> @@ -80,8 +82,9 @@ call_usermodehelper_keys(char *path, cha
>  			 struct key *session_keyring, enum umh_wait wait)
>  {
>  	struct subprocess_info *info;
> +	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
>  
> -	info = call_usermodehelper_setup(path, argv, envp);
> +	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
>  	if (info == NULL)
>  		return -ENOMEM;
>  
> Index: b/kernel/sys.c
> ===================================================================
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1795,7 +1795,7 @@ int orderly_poweroff(bool force)
>  		goto out;
>  	}
>  
> -	info = call_usermodehelper_setup(argv[0], argv, envp);
> +	info = call_usermodehelper_setup(argv[0], argv, envp, GFP_ATOMIC);
>  	if (info == NULL) {
>  		argv_free(argv);
>  		goto out;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

