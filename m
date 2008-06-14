Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYFNCvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYFNCvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 22:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYFNCuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 22:50:54 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:2861 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbYFNCux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 22:50:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xugu9lhQ2SxtVUhecE6NycQO/X0icNBiCCYC/TJORPAXhLQEis+nMqMB1uDmdmfks2
         CzYQfpLXN0mVfsiyK4KvlfOtRlCfe7dPuGWZvMMQS6GSUWdyE/FM43DPq3Lk0cDzAWbg
         u7QeCsYNOW8Hcc055QH9TcbfURJ6XhexsY75A=
Message-ID: <a8e1da0806131950i4eb0ea48q5cc34ea07cfd523a@mail.gmail.com>
Date: Sat, 14 Jun 2008 10:50:51 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [patch 16/47] bluetooth: fix locking bug in the rfcomm socket cleanup handling
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, "Willy Tarreau" <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Arjan van de Ven" <arjan@linux.intel.com>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Chris Wright" <chrisw@sous-sol.org>
In-Reply-To: <20080614001058.GP24698@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080613234753.235721454@mini.kroah.org>
	 <20080614000840.GA24659@suse.de> <20080614001058.GP24698@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 8:10 AM, Greg KH <gregkh@suse.de> wrote:
> -stable review patch.  If anyone has any objections, please let us know.
>
> ------------------
> From: Arjan van de Ven <arjan@linux.intel.com>
>
> [ Upstream commit: 7dccf1f4e1696c79bff064c3770867cc53cbc71c ]

Hi greg
Please including following commit as well because it will cause another bug:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=537d59af73d894750cff14f90fe2b6d77fbab15b

>
> in net/bluetooth/rfcomm/sock.c, rfcomm_sk_state_change() does the
> following operation:
>
>        if (parent && sock_flag(sk, SOCK_ZAPPED)) {
>                /* We have to drop DLC lock here, otherwise
>                 * rfcomm_sock_destruct() will dead lock. */
>                rfcomm_dlc_unlock(d);
>                rfcomm_sock_kill(sk);
>                rfcomm_dlc_lock(d);
>        }
> }
>
> which is fine, since rfcomm_sock_kill() will call sk_free() which will call
> rfcomm_sock_destruct() which takes the rfcomm_dlc_lock()... so far so good.
>
> HOWEVER, this assumes that the rfcomm_sk_state_change() function always gets
> called with the rfcomm_dlc_lock() taken. This is the case for all but one
> case, and in that case where we don't have the lock, we do a double unlock
> followed by an attempt to take the lock, which due to underflow isn't
> going anywhere fast.
>
> This patch fixes this by moving the stragling case inside the lock, like
> the other usages of the same call are doing in this code.
>
> This was found with the help of the www.kerneloops.org project, where this
> deadlock was observed 51 times at this point in time:
> http://www.kerneloops.org/search.php?search=rfcomm_sock_destruct
>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> Acked-by: Marcel Holtmann <marcel@holtmann.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
>  net/bluetooth/rfcomm/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/net/bluetooth/rfcomm/core.c
> +++ b/net/bluetooth/rfcomm/core.c
> @@ -423,8 +423,8 @@ static int __rfcomm_dlc_close(struct rfc
>
>                rfcomm_dlc_lock(d);
>                d->state = BT_CLOSED;
> -               rfcomm_dlc_unlock(d);
>                d->state_change(d, err);
> +               rfcomm_dlc_unlock(d);
>
>                skb_queue_purge(&d->tx_queue);
>                rfcomm_dlc_unlink(d);
>
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards
dave
