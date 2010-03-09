Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab0CIUMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:12:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61751 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab0CIUMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:12:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH 2/3] input: use input_mutex instead of BKL when opening input device
Date: Tue, 9 Mar 2010 21:12:13 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Kacur <jkacur@gmail.com>
References: <1268162386-2745-1-git-send-email-cascardo@holoscopio.com> <1268162386-2745-2-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <1268162386-2745-2-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003092112.14071.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19011Ys9rPGogO0axs4ZsQqKcdoyDTMAicfCyT
 l1jrCo+dVDbxPechjfqiy4puyqSMQowftP3a1eU15tj+n58uma
 bnrTcn3Vk7OQEi0dbAO8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 March 2010, Thadeu Lima de Souza Cascardo wrote:
>  MODULE_AUTHOR("Vojtech Pavlik <vojtech@suse.cz>");
> @@ -1881,7 +1880,7 @@ static int input_open_file(struct inode *inode, struct file *file)
>         const struct file_operations *old_fops, *new_fops = NULL;
>         int err;
>  
> -       lock_kernel();
> +       mutex_lock(&input_mutex);
>         /* No load-on-demand here? */
>         handler = input_table[iminor(inode) >> 5];
>         if (!handler || !(new_fops = fops_get(handler->fops))) {
> @@ -1909,7 +1908,7 @@ static int input_open_file(struct inode *inode, struct file *file)
>         }
>         fops_put(old_fops);
>  out:
> -       unlock_kernel();
> +       mutex_unlock(&input_mutex);
>         return err;
>  }
>  
> -- 

Well, actually please have a look at
http://git.kernel.org/?p=linux/kernel/git/arnd/playground.git;a=commitdiff;h=c06fd0234357618a5741ce958d58901ae4cb7ac1

* use mutex_lock_interruptible() where possible
* you probably don't want to hold input_mutex when calling into the lower
  device's open function

	Arnd
