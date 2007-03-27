Return-Path: <linux-kernel-owner+w=401wt.eu-S965508AbXC0Vey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965508AbXC0Vey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965496AbXC0Vey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:34:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:29641 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965509AbXC0Vex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:34:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XR3m6j5eybhkhsZ2x6LDlUvPIsqF09mIa8zBCBhM0quDoqdNiSgTM78Wfm+KXzp2JMe7ZrlBOcF06Bm1tN2eYiMN8BWBVTawrk2LYvIURRtvJM/pXNYyu3UCgUcBM1uaMmus1TTue1XgBahbk8ZGe2xaCpEcCV1B1sIrouXV+0Q=
Message-ID: <38b3b7c0703271434u2fddc4d1jc2b9af097e9c95b2@mail.gmail.com>
Date: Tue, 27 Mar 2007 23:34:51 +0200
From: "johann deneux" <johann.deneux@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom driver]
Cc: "Dmitry Torokhov" <dtor@insightbb.com>,
       "=?ISO-8859-1?Q?\"STenyaK_(Bruno_Gonz=E1lez)\"?=" <stenyak@gmail.com>,
       "Anssi Hannula" <anssi.hannula@gmail.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <460983D6.7070409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2460126662758025813@fi.muni.cz> <46018FB8.1080601@gmail.com>
	 <38b3b7c0703211503s3a8ee177v5b149cfd5975de8c@mail.gmail.com>
	 <200703221150.12403.dtor@insightbb.com> <46090BF2.2000105@gmail.com>
	 <38b3b7c0703271136s799114fcndfaa6de8db52fc70@mail.gmail.com>
	 <46097A68.6080802@gmail.com>
	 <38b3b7c0703271343p6a56fed8i950941e8cef196d8@mail.gmail.com>
	 <460983D6.7070409@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/07, Jiri Slaby <jirislaby@gmail.com> wrote:

> Ok, so how to deal with these devices? Does anybody have some idea? That's
> what I was talking about somewhere in the beginning of this thread, the raw
> values, because it seems too specific for letting kernel to cope with each
> of these devices separately, but there might be a better idea in somebody's
> head? But raw is ugly...
>

What about adding a member to ff_effect which would be the number of the motor?
We can't change the layout of ff_effect too much though, so we have to
find unused bits and put them to work.

For instance, we could replace

__u16 type;

by

__u8 motor;
__u8 type;

since 16 bits seems way more than needed for the effect type.

Another possibility is to get rid of "trigger" and replace it by __u8
motor and some padding, since that's I-Force specific (are there other
drivers that implement that?). The goal of "trigger" is to start an
effect when a button is pressed, which can be done from userland
instead. It's not like we need micro-second latency when starting
effects.

As a reminder, here is the current definition of ff_effect:

struct ff_effect {
       __u16 type;
       __s16 id;
       __u16 direction;
       struct ff_trigger trigger;
       struct ff_replay replay;

       union {
               struct ff_constant_effect constant;
               struct ff_ramp_effect ramp;
               struct ff_periodic_effect periodic;
               struct ff_condition_effect condition[2]; /* One for each axis */
               struct ff_rumble_effect rumble;
       } u;
};

-- 
Johann
