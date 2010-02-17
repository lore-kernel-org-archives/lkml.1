Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab0BQPjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 10:39:44 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:64468 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923Ab0BQPjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 10:39:43 -0500
Message-ID: <4B7C0DBB.5010801@rsk.demon.co.uk>
Date: Wed, 17 Feb 2010 15:39:39 +0000
From: Richard Kennedy <richard@rsk.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] vt: Fix refcounting use
References: <20100217131931.17289.68158.stgit@localhost.localdomain> <20100217132317.17289.61570.stgit@localhost.localdomain>
In-Reply-To: <20100217132317.17289.61570.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/02/10 13:23, Alan Cox wrote:
> We want to properly refcount the vc tty because of the cases where a vc is
> disassociated from a tty (eg destroyed). At the moment the code isn't safe
> and in fact input even tries to patch up broken pointers as a result!
>
>   static void applkey(struct vc_data *vc, int key, char mode)
> @@ -497,10 +499,12 @@ static void fn_show_ptregs(struct vc_data *vc)
>
>   static void fn_hold(struct vc_data *vc)
>   {
> -	struct tty_struct *tty = vc->port.tty;
> +	struct tty_struct *tty = tty_port_tty_get(&vc->port);
>
> -	if (rep || !tty)
> +	if (rep || !tty) {
> +	        tty_kref_put(tty);
>   		return;
> +        }
>

This is the only bit that immediately stands out..
maybe?
	if (rep || !tty) {
		if (tty)
			tty_kref_put(tty);
		return;
	}

regards
Richard

