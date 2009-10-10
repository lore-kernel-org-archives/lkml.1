Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbZJJXFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbZJJXFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 19:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbZJJXFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 19:05:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51876 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754547AbZJJXFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 19:05:45 -0400
Date: Sun, 11 Oct 2009 00:06:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bernhard Walle <bernhard@bwalle.de>
Cc: akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
       Bernhard Walle <bernhard@bwalle.de>
Subject: Re: [PATCH 3/5] Use vt_get_kmsg_redirect() and
 vt_set_kmsg_redirect()
Message-ID: <20091011000632.3148849e@lxorguk.ukuu.org.uk>
In-Reply-To: <1255207870-24496-4-git-send-email-bernhard@bwalle.de>
References: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>
	<1255207870-24496-4-git-send-email-bernhard@bwalle.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	kmsg_redirect = SUSPEND_CONSOLE;
> +	orig_kmsg = vt_get_kmsg_redirect();
> +	vt_set_kmsg_redirect(SUSPEND_CONSOLE);

Probably better to have a single

	orig_kmsg = vt_kmsg_redirect(new);

because it makes the locking easy and means a third party can't sneak
between those two and break stuff. This has another advantage - the
variable is now function local and the whole pile of stuff you posted
becomes

#if defined(CONFIG_VT_CONSOLE)

extern inline int vt_kmsg_redirect(int new)
{
	static int kmsg_con;

	if (new != -1)
		xchg(new, &kmsg_con);
	else
		new = kmsg_con;
	return new;
}

#else

extern inline int vt_kmsg_redirect(int new)
{
	return 0;
}

#endif


Optionally adding

#define vt_get_kmsg_redirect vt_kmsg_redirect(-1);


One ifdef, clear locking rules, no globals, no file level statics and for
almost all cases it'll compile down to almost nothing.

Alan
