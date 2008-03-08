Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbYCHXHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbYCHXHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 18:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYCHXH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 18:07:29 -0500
Received: from web36606.mail.mud.yahoo.com ([209.191.85.23]:41560 "HELO
	web36606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751344AbYCHXH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 18:07:28 -0500
X-YMail-OSG: HYX9_ccVM1mo8X0_lBL_D5iEus..5lBAR1WEWCgZF33DCg7KzEdZ6ubSRYIDsVY1vivrcbrIJhBhShdL8GpP6mLt
X-RocketYMMF: rancidfat
Date: Sat, 8 Mar 2008 15:07:25 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH BUGFIX -rc4] Smackfs: Do not trust `count' in inodes write()s
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>,
       akpm <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus <torvalds@linux-foundation.org>
In-Reply-To: <20080308213826.GA22536@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <899120.95464.qm@web36606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> Hi all,
> 
> Smackfs write() implementation does not put a higher bound on the 
> number of bytes to copy from user-space. This may lead to a DOS
> attack if a malicious `count' field is given. 
> 
> Assure that given `count' is exactly the length needed for a 
> /smack/load rule. In case of /smack/cipso where the length is 
> relative, assure that `count' does not exceed the size needed for 
> a buffer representing maximum possible number of CIPSO 2.2 
> categories.
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

One has trouble being too careful these days.

> ---
> 
>  smack.h   |    8 --------
>  smackfs.c |   31 ++++++++++++++++++++-----------
>  2 files changed, 20 insertions(+), 19 deletions(-)
> 
> Smack user-space utilities (smackload, smackcipso) still work 
> fine after below change.
> 
> [
>   Who's responsible for forwarding Smack patches to Linus ?
>   I've CCed Andrew and Linus just in case.
> ]
> 
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index c444f48..4a4477f 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -27,14 +27,6 @@
>  #define SMK_MAXLEN	23
>  #define SMK_LABELLEN	(SMK_MAXLEN+1)
>  
> -/*
> - * How many kinds of access are there?
> - * Here's your answer.
> - */
> -#define SMK_ACCESSDASH	'-'
> -#define SMK_ACCESSLOW	"rwxa"
> -#define SMK_ACCESSKINDS	(sizeof(SMK_ACCESSLOW) - 1)
> -
>  struct superblock_smack {
>  	char		*smk_root;
>  	char		*smk_floor;
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index effd3de..3fc3a07 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -81,10 +81,23 @@ static struct semaphore smack_write_sem;
>  /*
>   * Values for parsing cipso rules
>   * SMK_DIGITLEN: Length of a digit field in a rule.
> - * SMK_CIPSOMEN: Minimum possible cipso rule length.
> + * SMK_CIPSOMIN: Minimum possible cipso rule length.
> + * SMK_CIPSOMAX: Maximum possible cipso rule length.
>   */
>  #define SMK_DIGITLEN 4
> -#define SMK_CIPSOMIN (SMK_MAXLEN + 2 * SMK_DIGITLEN)
> +#define SMK_CIPSOMIN (SMK_LABELLEN + 2 * SMK_DIGITLEN)
> +#define SMK_CIPSOMAX (SMK_CIPSOMIN + SMACK_CIPSO_MAXCATNUM * SMK_DIGITLEN)
> +
> +/*
> + * Values for parsing MAC rules
> + * SMK_ACCESS: Maximum possible combination of access permissions
> + * SMK_ACCESSLEN: Maximum length for a rule access field
> + * SMK_LOADLEN: Smack rule length
> + */
> +#define SMK_ACCESS    "rwxa"
> +#define SMK_ACCESSLEN (sizeof(SMK_ACCESS) - 1)
> +#define SMK_LOADLEN   (SMK_LABELLEN + SMK_LABELLEN + SMK_ACCESSLEN)
> +
>  
>  /*
>   * Seq_file read operations for /smack/load
> @@ -229,14 +242,10 @@ static void smk_set_access(struct smack_rule *srp)
>   * The format is exactly:
>   *     char subject[SMK_LABELLEN]
>   *     char object[SMK_LABELLEN]
> - *     char access[SMK_ACCESSKINDS]
> - *
> - *     Anything following is commentary and ignored.
> + *     char access[SMK_ACCESSLEN]
>   *
> - * writes must be SMK_LABELLEN+SMK_LABELLEN+4 bytes.
> + * writes must be SMK_LABELLEN+SMK_LABELLEN+SMK_ACCESSLEN bytes.
>   */
> -#define MINIMUM_LOAD (SMK_LABELLEN + SMK_LABELLEN + SMK_ACCESSKINDS)
> -
>  static ssize_t smk_write_load(struct file *file, const char __user *buf,
>  			      size_t count, loff_t *ppos)
>  {
> @@ -253,7 +262,7 @@ static ssize_t smk_write_load(struct file *file, const
> char __user *buf,
>  		return -EPERM;
>  	if (*ppos != 0)
>  		return -EINVAL;
> -	if (count < MINIMUM_LOAD)
> +	if (count != SMK_LOADLEN)
>  		return -EINVAL;
>  
>  	data = kzalloc(count, GFP_KERNEL);
> @@ -513,7 +522,7 @@ static ssize_t smk_write_cipso(struct file *file, const
> char __user *buf,
>  		return -EPERM;
>  	if (*ppos != 0)
>  		return -EINVAL;
> -	if (count <= SMK_CIPSOMIN)
> +	if (count < SMK_CIPSOMIN || count > SMK_CIPSOMAX)
>  		return -EINVAL;
>  
>  	data = kzalloc(count + 1, GFP_KERNEL);
> @@ -547,7 +556,7 @@ static ssize_t smk_write_cipso(struct file *file, const
> char __user *buf,
>  	if (ret != 1 || catlen > SMACK_CIPSO_MAXCATNUM)
>  		goto out;
>  
> -	if (count <= (SMK_CIPSOMIN + catlen * SMK_DIGITLEN))
> +	if (count != (SMK_CIPSOMIN + catlen * SMK_DIGITLEN))
>  		goto out;
>  
>  	memset(mapcatset, 0, sizeof(mapcatset));
> 
> Regards,
> 
> -- 
> 
> "Better to light a candle, than curse the darkness"
> 
> Ahmed S. Darwish
> Homepage: http://darwish.07.googlepages.com
> Blog: http://darwish-07.blogspot.com
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
