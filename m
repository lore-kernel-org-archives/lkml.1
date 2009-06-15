Return-Path: <linux-kernel-owner+w=401wt.eu-S1757128AbZFOIND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128AbZFOIND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZFOIMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:12:47 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:46264 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZFOIMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:12:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ib16Q/tb4M872y2KH9bJE12DSQbn0G5qIUjt/h3TaIY0GuCEyEN2I8TlY2D/ECJvNa
         MAYdR+Auc2tPD/RTyNndBzIx26nCF/NRUeBARHyiOU6SSBC/2JuUBUWhuMIZyBA25yd3
         LAYtXQZAyZhEuU5i0wr9OfE/pqQEL4VeF0C9k=
MIME-Version: 1.0
In-Reply-To: <61b223ba0906150109r3a69e98aq949c7f2df5563c6e@mail.gmail.com>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk>
	 <20090404041813.GA30746@srcf.ucam.org>
	 <9b2b86520906080824i134ee546v33990176b0d3e618@mail.gmail.com>
	 <71cd59b00906130155u2757ade3t3378685846b80410@mail.gmail.com>
	 <4A337251.7010705@tuffmail.co.uk>
	 <71cd59b00906130306w319c0fc2i376bb03323845b80@mail.gmail.com>
	 <507032D758%linux@youmustbejoking.demon.co.uk>
	 <9b2b86520906131051t32183554r8208cf886609e09c@mail.gmail.com>
	 <71cd59b00906141226k37b90b9ey7347ed85ec17a17b@mail.gmail.com>
	 <61b223ba0906150109r3a69e98aq949c7f2df5563c6e@mail.gmail.com>
Date: Mon, 15 Jun 2009 09:12:47 +0100
Message-ID: <9b2b86520906150112j62b10172j33566f8297850c76@mail.gmail.com>
Subject: Re: [PATCH 2.6.29] eeepc-laptop: report brightness control events via 
	the input layer
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: gnome-power-manager-list@gnome.org
Cc: Corentin Chary <corentin.chary@gmail.com>, linux-kernel@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/09, Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
> On 14/06/2009, Corentin Chary <corentin.chary@gmail.com> wrote:
>> CCed gnome-power-manager, as it seems to be the only userspace program
>> concerned.

Warning pour les autres: subscription-only mailing list.

Posts on the g-p-m list will be subject to moderation and delays.

>> You may be able to help us here.
>>
>> You can find the complet discussion here:
>> http://groups.google.com/group/linux.kernel/browse_thread/thread/a7bef6cffb7c2d6b/c732f616555d5180?#c732f616555d5180
>
> Since this is my complaint, I'll try to summarize.
>
>
> Summary: g-p-m's reaction to brightness events makes the brightness
> changes less reliable
> Severity: cosmetic; decrease in quality of user experience
>
> Hardware: Asus Eee PC.
> Software: linux kernel, gnome-power-manager
>
> Last working version: linux 2.6.29.4
> First broken version: linux 2.6.30
>
> Root cause:
> 1) The eeepc-laptop platform driver added support for brightness
> events.  They occur when the brightness up/down keys are pressed, and
> are exported as normal keypresses (on a specific input device).  This
> is apparently the same thing other kernel drivers do on other systems.
>
> 2) g-p-m isn't sure whether the firmware is changing the brightness
> when the brightness keys are pressed.  (The EeePc firmware does change
> the brightness, like most laptops).  It has a workaround for this
> problem, but it isn't completely reliable.  In some cases g-p-m gets
> it wrong, and changes the brightness a second time.
>
> You can see the problem by looking at the code, and considering what
> happens when more than one input event is buffered at a time:
>
> 	/* check to see if the panel has changed */
> 	gpm_brightness_lcd_get_hw (brightness, &current_hw);
>
> 	/* the panel has been updated in firmware */
> 	if (current_hw != brightness->priv->last_set_hw) {
> 		brightness->priv->last_set_hw = current_hw;
> 	} else {
> 		[ increment the brightness ]
> 	}
>
> The first event will be ignored as expected.  But on the second event,
> g-p-m will re-apply the brightness change.  It doesn't notice that the
> brightness jumped _several_ steps before it processed the first event.
>
> Symptoms:
> 1) When thrashing the EeePC's cheap sold-state drive, the system
> becomes much slower to respond.  If you tap the brightness up key
> three times, you can see the brightness jump more than 3 steps.  The
> first 3 steps are immediate, then g-p-m appears to "catch up", and
> erroneously re-apply the brightness changes.
>
> This is a neat way to demonstrate the problem (see upthread for exact
> reproduction steps), but we don't really care too much about it.
> Laggy systems are laggy and strange.  I don't find this surprising and
> I think most users will accept it, even if we could do better.
>
> 2) Switching quickly between holding "brightness down" and "brightness
> up" can cause a flicker/flash of brightness.  This flash goes away
> when g-p-m is killed (or on older kernels).
>
> More specifically:
> i) Set the screen to maximum brightness
> ii) Hold down "brightness down"
> iii) When brightness is at minimum, immediately release it and hold
> down "brightness up" (or quickly tap it multiple times).
>
> What probably happens is that g-p-m "falls behind" during step ii).
> During step ii), all this does is cause the brightness to change a
> little bit faster.  However, it means that in step iii), it's still
> trying to decrease the brightness when the firmware starts to increase
> the brightness.  So during step iii) I think you see the firmware
> increase the brightness, then g-p-m decrease the brightness, and then
> g-p-m catches up and the brightness increases again.
>
> This crosses my annoyance threshold.  That's partly because it's a
> regression, and because I've spent a lot of time tracking down
> brightness-change related regressions which ultimately crashed the
> entire system.  But I do think it's an annoyance in it's own right.
> It's definitely a realistic scenario.  One will often move these small
> laptops around and adjust the brightness to suit different light
> conditions.
>
> Thanks
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
