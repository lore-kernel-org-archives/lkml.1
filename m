Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbYCaOb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbYCaOb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbYCaObs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:31:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:65304 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYCaObr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:31:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=m7V14JQE6WW68+G/Cnh87KriWnWUve/VZaWqAjm/YS4hVr3RtCkvOgpr2C5ltUhwisg2kL8cDK/T8OxRQhOobu0O5ouGACTjiN7PA//Tcl1A2gbtQ92QjsrpxQKJ3QqL1kQlgOmtKDuE9v+4wXrWvw+Fnbov8B1h8Z/PJH302BY=
Message-ID: <47F0F5CA.8050404@gmail.com>
Date: Mon, 31 Mar 2008 18:31:38 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [Pull] Some documentation patches
References: <13387.1206728412@vena.lwn.net> <alpine.LNX.1.10.0803282005440.27567@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0803282005440.27567@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt пишет:
> 
> On Friday 2008-03-28 19:20, Jonathan Corbet wrote:
>> commit 9756ccfda31b4c4544aa010aacf71b6672d668e8
>> Date:   Fri Mar 28 11:19:56 2008 -0600
>>
>>    Add the seq_file documentation
> 
> patch on top:
> 
>  - add const qualifiers
>  - remove void* casts
>  - use proper specifier (%Ld is not valid)
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> diff --git a/Documentation/filesystems/seq_file.txt
> b/Documentation/filesystems/seq_file.txt
> index 92975ee..cc6cdb9 100644
> --- a/Documentation/filesystems/seq_file.txt
> +++ b/Documentation/filesystems/seq_file.txt
> @@ -107,8 +107,8 @@ complete. Here's the example version:
> 
>      static void *ct_seq_next(struct seq_file *s, void *v, loff_t *pos)
>      {
> -            loff_t *spos = (loff_t *) v;
> -            *pos = ++(*spos);
> +            loff_t *spos = v;
> +            *pos = ++*spos;

Excuse me, what's the point in this change and the next one? IMO, removing
the explicit type cast makes the code less obvious (AFAICT, this is a trendy
word in LKML these days). Relying upon operator priorities instead of explicit
operator grouping using parentheses can confuse people, too. Imagine a
person looking at these lines: after the change, he or she will need to check
the variable v type in the argument list, and consult the table of operator
priorities in C if the person is in doubt about what the code does.

Just my two cents...

Dmitri

>              return spos;
>      }
> 
> @@ -127,8 +127,8 @@ something goes wrong. The example module's show()
> function is:
> 
>      static int ct_seq_show(struct seq_file *s, void *v)
>      {
> -            loff_t *spos = (loff_t *) v;
> -            seq_printf(s, "%Ld\n", *spos);
> +            loff_t *spos = v;
> +            seq_printf(s, "%lld\n", (long long)*spos);
>              return 0;
>      }
> 
> @@ -136,7 +136,7 @@ We will look at seq_printf() in a moment. But first,
> the definition of the
>  seq_file iterator is finished by creating a seq_operations structure with
>  the four functions we have just defined:
> 
> -    static struct seq_operations ct_seq_ops = {
> +    static const struct seq_operations ct_seq_ops = {
>              .start = ct_seq_start,
>              .next  = ct_seq_next,
>              .stop  = ct_seq_stop,
> @@ -204,7 +204,7 @@ line, as in the example module:
>      static int ct_open(struct inode *inode, struct file *file)
>      {
>          return seq_open(file, &ct_seq_ops);
> -    };
> +    }
> 
>  Here, the call to seq_open() takes the seq_operations structure we created
>  before, and gets set up to iterate through the virtual file.
> @@ -219,7 +219,7 @@ The other operations of interest - read(), llseek(),
> and release() - are
>  all implemented by the seq_file code itself. So a virtual file's
>  file_operations structure will look like:
> 
> -    static struct file_operations ct_file_ops = {
> +    static const struct file_operations ct_file_ops = {
>              .owner   = THIS_MODULE,
>              .open    = ct_open,
>              .read    = seq_read,
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

