Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbYJUGmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbYJUGmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 02:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYJUGmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 02:42:37 -0400
Received: from lazybastard.de ([212.112.238.170]:36387 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbYJUGmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 02:42:37 -0400
Date: Tue, 21 Oct 2008 08:41:45 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
Message-ID: <20081021064144.GC30563@logfs.org>
References: <20081017171139.GA1792@elte.hu> <ada3aiv9k6j.fsf@cisco.com> <20081017180523.GA11590@elte.hu> <adatzbbrrcf.fsf@cisco.com> <20081017191202.GA5396@elte.hu> <adaiqrrrp2h.fsf@cisco.com> <20081018082209.GA24220@elte.hu> <alpine.LFD.2.00.0810200933470.3518@nehalem.linux-foundation.org> <20081020192110.GA28736@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081020192110.GA28736@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 October 2008 21:21:10 +0200, Ingo Molnar wrote:
>  
>  /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
>  #define fops_get(fops) \
> -	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
> +	(((fops != NULL) && try_module_get((fops)->owner) ? (fops) : NULL))
>  #define fops_put(fops) \
> -	do { if (fops) module_put((fops)->owner); } while(0)
> +	do { if (fops != NULL) module_put((fops)->owner); } while(0)

This, I would argue, makes the code worse.

> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 6272a39..a3f78d0 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -580,7 +580,8 @@ extern int audit_enabled;
>  #define audit_log(c,g,t,f,...) do { ; } while (0)
>  #define audit_log_start(c,g,t) ({ NULL; })
>  #define audit_log_vformat(b,f,a) do { ; } while (0)
> -#define audit_log_format(b,f,...) do { ; } while (0)
> +static inline void __attribute__ ((format(printf, 2, 3)))
> +audit_log_format(struct audit_buffer *ab, const char *fmt, ...) { }

Took me a moment to notice the two lines aren't independent.  A tab
would have been appreciated.

> diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
> index 427b820..ac55b62 100644
> --- a/drivers/net/wireless/b43/b43.h
> +++ b/drivers/net/wireless/b43/b43.h
> @@ -853,7 +853,8 @@ void b43warn(struct b43_wl *wl, const char *fmt, ...)
>  void b43dbg(struct b43_wl *wl, const char *fmt, ...)
>      __attribute__ ((format(printf, 2, 3)));
>  #else /* DEBUG */
> -# define b43dbg(wl, fmt...) do { /* nothing */ } while (0)
> +static inline void __attribute__ ((format(printf, 2, 3)))
> +b43dbg(struct b43_wl *wl, const char *fmt, ...) { }

Dito.

Jörn

-- 
A victorious army first wins and then seeks battle.
-- Sun Tzu
