Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbYANQAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbYANQAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:00:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbYANP73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:59:29 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:21931 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbYANP72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:59:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tnaY6oYt0X8gH2k9ZOB3kb9IM3cOtzkklTe9HhFpfHBEr+NztCqF0cAuqFzAs6xWxtniP8XyrkQ+LA9P+E9RREAwU0ad9rQ/GMSh79zfsvyOaN4mv63AvtAafkNVqW1dAdvwEIwIcgvwpQM7Sn3wj0HgTIX+y9XnHZswae7g/tw=
Message-ID: <478B86DA.1010902@gmail.com>
Date: Mon, 14 Jan 2008 16:59:22 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Paul Gortmaker <p_gortmaker@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] driver: ip27-rtc - convert ioctl to unlocked_ioctl
References: <20080113203223.GA6723@cvg> <478A8131.9050500@gmail.com> <478A82AD.3070904@gmail.com> <aa79d98a0801131332w45d6e0e9r13e96b69e7e1b70@mail.gmail.com> <aa79d98a0801132238o72266a91p78ae3a0c1476607c@mail.gmail.com> <478B7C4A.5090903@gmail.com> <20080114153806.GA6639@cvg>
In-Reply-To: <20080114153806.GA6639@cvg>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2008 04:38 PM, Cyrill Gorcunov wrote:
> Jiri, I mean rtc_open() is protected by spinlock+status from being
> opened simultaneously by a few processes. *But* lets imagine the
> following situation - this fd (file descriptor) is opened by one
> multithreaded application so all threads have an access to this
> fd. Then one thread reads rtc periodically thru unlocked_ioctl
> and another thread set new time from time to time. So the question
> I have - is it possible to get second thread stopped at attemption to
> get rtc spinlock while another thread is setting the new time? Or
> this situation never-ever could be? i'm not really familiar with
> process management in Linux and as result could be wrong.

Access to global variable 'rtc' (the rtc itself) is serialized through the 
spinlock, I see no problem there. If you call read-read-write-read from 4 tasks 
in userspace, it might be _still_ (no change) reordered to e.g. 
write-read-read-read by the scheduler.

In fact, the reading process is stopped while the another one is writing the 
time (due to spinlock).
