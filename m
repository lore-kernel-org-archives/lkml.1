Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbYJGSOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbYJGSOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 14:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbYJGSOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 14:14:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46335 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755519AbYJGSOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 14:14:21 -0400
Date: Tue, 7 Oct 2008 19:14:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Holden <aciddeath@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: BKL still required for what functions?
Message-ID: <20081007191409.4a7291ff@lxorguk.ukuu.org.uk>
In-Reply-To: <786804A2-4288-46F5-82B8-3FF9B6FD196C@gmail.com>
References: <F99FEC4F-DEDD-4E55-93B4-A0761F30E1A2@gmail.com>
	<20081007173515.1c161dce@lxorguk.ukuu.org.uk>
	<786804A2-4288-46F5-82B8-3FF9B6FD196C@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	lock_kernel();
> +	
>   	mutex_lock(&phone_lock);
>   	p = phone_device[minor];
>   	if (p)
>   		new_fops = fops_get(p->f_op);
>   	if (!new_fops) {
>   		mutex_unlock(&phone_lock);
> +		lock_kernel();
>   		request_module("char-major-%d-%d", PHONE_MAJOR, minor);
> +		unlock_kernel();
>   		mutex_lock(&phone_lock);
>   		p = phone_device[minor];
>   		if (p == NULL || (new_fops = fops_get(p->f_op)) == NULL)
> @@ -81,7 +83,6 @@ static int phone_open(struct inode *inode, struct  
> file *file)
>   	fops_put(old_fops);
>   end:
>   	mutex_unlock(&phone_lock);
> -	unlock_kernel();
>   	return err;
>   }

Looks like the BKL can go entirely there providing phone_device[] is
always rechecked back in the phone mutex, request_module is happy nowdays
without the BKL
