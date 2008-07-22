Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbYGVNxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbYGVNxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbYGVNxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:53:05 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:39910 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYGVNxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:53:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-description:content-disposition:in-reply-to
         :user-agent;
        b=RohW27q2592epHT+POWloi3h4nxj2kDOaTsZSVmaxAidtruL/H170/tyWMh7rLmgaj
         TnWxOWpc9kB7vwls80HTzPxwzbcSCA/C2aWu1h4AMqzGA7i3URV6DqGKSF6oHTR257eq
         pUQKJ3gUCBqfXvz761RoU6MwH76MJGgfcbIGQ=
Date: Tue, 22 Jul 2008 09:52:58 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       robfitz@273k.net, akpm@osdl.org, jikos@jikos.cz, vojtech@suse.cz,
       dmonakhov@openvz.org, johannes@sipsolutions.net,
       Oliver Neukum <oliver@neukum.org>, stern@rowland.harvard.edu
Subject: Re: [PATCH] linux-input: bcm5974-0.57: mode-switch to atp_open,
	cleanup bug fixed
Message-ID: <20080722093606.ZZRA012@mailhub.coreip.homeip.net>
References: <1216466049.6238.0.camel@alnilam> <20080720051016.GA7853@anvil.corenet.prv> <1216688142.4768.26.camel@alnilam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Description: uplicated.uplicated.
Content-Disposition: inline
In-Reply-To: <1216688142.4768.26.camel@alnilam>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 02:55:42AM +0200, Henrik Rydberg wrote:
> Hi Dmitri,
> 
> Regarding open/close and suspend/resume, I have difficulties finding out
> what the proper behavior is for the various error states that can
> appear. I also wonder whether open should commute with suspend or not.
> It would be of great help to get answers to the scenarios below.
>

Hm, hard questions. I will try answering them but I am also CCing Alan
Stern and Oliver Neikum who are experts in USB suspend/resume.
 
> 1. From the state (!opened,!suspended), calling open followed by
> suspend, or suspend followed by open, are we in the same state?
>

No, we are not... if we first open then suspend then device stays open
but we are not getting reports from it. Opening suspended device will
fail. Autosuspended device should be waken up by open() though.
 
> 2. From the state (!opened,!suspended), calling open fails. What state
> are we in?

Device is closed, the driver will have to make sure that it cleans up
steps that succeded while opening device (like if you submitted 1 URB
successfully and the 2nd URB failed open should kill the first one
before returning).

> 
> 3. From the state (!opened,suspended), calling open gets us to what
> state?
>

Depens on the kind of suspend - manual suspend will cause open to
fail. Autosuspend (if driver implements it) should resume the device.

> 4. From the state (!opened,suspended), calling open fails. Where are we?
>

Manual suspend will surely cause open to fail. Autosuspend - if
autoresume fails then (closed, unknown) otherwise (closed,
autosuspended - autosuspension may not kick in immediately I think).

> 5. From the state (opened,suspended), calling resume fails. What state
> are we in?
> 

Screwed up ;) From the driver POV still (opened, suspended) I think.

Thanks!

-- 
Dmitry
