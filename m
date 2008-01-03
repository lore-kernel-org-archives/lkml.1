Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbYACOQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbYACOQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 09:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbYACOQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 09:16:04 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:64815 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbYACOQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 09:16:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ir3MeQf8bJU0DiJruqxMHXdnfJDbirf9QlU8Sr7ok0i6iBGggkrdXtA82CISfIi4vo3ECmNR1i36UWpM5zLm2wygJGJC9r0BhXMfrTkAITgzwUtodvHTvqp0am26fLszo9FoEze0zCyPf1QWvcTv8l/GvG3ipLE7ADN6TZNwIVM=
Message-ID: <477CEE1C.7020005@gmail.com>
Date: Thu, 03 Jan 2008 15:15:56 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: isofs oops - d_splice_alias+0x1f (2.6.24-rc5-mm1)
References: <477CE1E0.4010504@gmail.com> <Pine.LNX.4.64.0801031550160.2076@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0801031550160.2076@sbz-30.cs.Helsinki.FI>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2008 02:51 PM, Pekka J Enberg wrote:
> Hi Jiri,
> 
> On Thu, 3 Jan 2008, Jiri Slaby wrote:
>> this happened, while playing with broken dvd.
> 
> [snip]
> 
>> Buffer I/O error on device sr0, logical block 5441
>> end_request: I/O error, dev sr0, sector 136
>> ISOFS: unable to read i-node block
>> Unable to handle kernel NULL pointer dereference at 00000000000000ad RIP:
>>  [<ffffffff802a679f>] d_splice_alias+0x1f/0x100
> 
> [snip]
> 
>> Call Trace:
>>  [<ffffffff880d2395>] :isofs:isofs_lookup+0x395/0x4a0
>>  [<ffffffff802a565b>] d_alloc+0x2b/0x1d0
>>  [<ffffffff8029a97c>] do_lookup+0x1ac/0x200
> 
> Does the following patch fix it?
> 
> 			Pekka
> 
> [PATCH] isofs: check for bad inode in isofs_lookup
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> If isofs_read_inode() fails to read one of the inode blocks from disk, it
> returns a bad inode.
> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  fs/isofs/namei.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> Index: linux-2.6/fs/isofs/namei.c
> ===================================================================
> --- linux-2.6.orig/fs/isofs/namei.c
> +++ linux-2.6/fs/isofs/namei.c
> @@ -183,6 +183,11 @@ struct dentry *isofs_lookup(struct inode
>  			unlock_kernel();
>  			return ERR_PTR(-EACCES);
>  		}
> +		if (is_bad_inode(inode)) {
> +			unlock_kernel();
> +			iput(inode);
> +			return ERR_PTR(-ENOENT);
> +		}
>  	}
>  	unlock_kernel();
>  	return d_splice_alias(inode, dentry);

Can't say, the DVD seems to be OK, I don't know what was wrong (as I can say,
this happened several times in the past yet and after reboot everything OK; I
suspect gnome auto mounter -- multiple machines, several DVD ROMs, same disk
with OS, similar errors, but that's too few to report).
