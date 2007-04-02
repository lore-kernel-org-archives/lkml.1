Return-Path: <linux-kernel-owner+w=401wt.eu-S933936AbXDBGsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936AbXDBGsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933941AbXDBGse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:48:34 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:58995 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933936AbXDBGsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 02:48:33 -0400
Date: Mon, 2 Apr 2007 08:48:12 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/16] show-pipesize-in-stat.diff
In-Reply-To: <20070401225833.ffb9fbd5.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0704020834370.1245@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704012010040.12316@yvahk01.tjqt.qr>
 <20070401225833.ffb9fbd5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 1 2007 22:58, Andrew Morton wrote:
>On Sun, 1 Apr 2007 20:17:24 +0200 (MEST) Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
>> Show the fill status of a pipe (in bytes) when stat'ing one.
>
>Is this useful?  It seems rather an obscure thing, and we generally need a
>good reason to go adding Linux-specific goodies to standard system calls
>like this.  What do "other operating systems" do here?

Other OS seem to always show 0, as Linux does usually. So I do not think
programs actually rely on it having any specific value.
I thought adding pipesize might be helpful in dianosing pipe cases, akin to
Miklos's procfs-fdinfo patch for regular files.

>> +		}
>> +	} else if (S_ISSOCK(inode->i_mode)) {
>> +#ifdef CONFIG_UNIX_MODULE
>> +		loff_t (*uxsize)(struct inode *) = __symbol_get("unixsock_size");
>> +		if (uxsize != NULL) {
>> +			stat->size = uxsize(inode);
>> +			symbol_put("unixsock_size");
>> +		}
>> +#endif
>> +#if defined(CONFIG_UNIX) && !defined(CONFIG_UNIX_MODULE)
>> +		stat->size = unixsock_size(inode);
>> +#endif
>> +	} else {
>> +		stat->size = i_size_read(inode);
>> +	}
>
>That's a bit fugly.

Drop for now.

>> +loff_t unixsock_size(struct inode *inode) {
>> +    struct sock *sk = unix_find_socket_byinode(inode);
>> +    loff_t eax;
>> +
>> +    if(sk == NULL) { return 0; }
>> +    eax = sk->sk_rcvbuf;
>> +    sock_put(sk);
>> +    return eax;
>> +}
>> +EXPORT_SYMBOL(unixsock_size);
>
>That's wildly incorrect coding style, and it doesn't use tabs.

Which means I something really went wrong, because I knew I went through it for
cleanup.
