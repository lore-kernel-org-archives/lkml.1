Return-Path: <linux-kernel-owner+w=401wt.eu-S1751806AbXD1UpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbXD1UpX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbXD1UpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:45:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:52065 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbXD1UpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=pt9VKzKrQdkiXVKOn2zy55dQr/iILDO19gxCN9tEgEHtyRbeLOflnisnAJfdhDwL3qCydqWs0roE46iSW5fd4GEMXacg0csu4yS6sOVf9mKEWzw+yQDIPwS2dw6MqVA+e0z9MumQ6m21QjKR8VJXa53E4E05xZ2hqNID5Et1+RY=
Message-ID: <75b66ecd0704281345u2479fb92w47a448053fff23b1@mail.gmail.com>
Date: Sat, 28 Apr 2007 16:45:19 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Kasper Sandberg" <lkml@metanurb.dk>
Subject: Re: [patch] CFS scheduler, -v6
Cc: "Ingo Molnar" <mingo@elte.hu>, "Gene Heskett" <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Con Kolivas" <kernel@kolivas.org>, "Nick Piggin" <npiggin@suse.de>,
       "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, caglar@pardus.org.tr,
       "Willy Tarreau" <w@1wt.eu>, "Mark Lord" <lkml@rtr.ca>,
       "Zach Carter" <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
In-Reply-To: <1177774551.21279.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070425214704.GA32572@elte.hu>
	 <1177596399.14496.1.camel@localhost>
	 <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
	 <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost>
X-Google-Sender-Auth: d12da0e50fa7c791
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/07, Kasper Sandberg <lkml@metanurb.dk> wrote:
> tried looking for buffer stuff in /proc/asound, couldnt find anything,
> im using the via82xx driver.
>

Use fuser to see which sound device is used:

$ fuser /dev/snd/*
/dev/snd/controlC0:  14028
/dev/snd/pcmC0D0c:   14028m
/dev/snd/pcmC0D0p:   14028m

So process 14028 is using capture device 0 substream 0 and playback
device 0 substream 0.  Examine the hw_params for playback device like
so:

$ cat /proc/asound/card0/pcm0p/sub0/hw_params
access: MMAP_INTERLEAVED
format: S16_LE
subformat: STD
channels: 2
rate: 48000 (48000/1)
period_size: 1024
buffer_size: 2048
tick_time: 1000

This application (jackd) is a sophisticated user of ALSA API and
allows the user to set period and buffer size but many apps just use
the default they get from ALSA.  These apps will work well with a
driver that happens to have a large default buffer but will fail
(skip) with drivers that default to a small buffer.

Lee
