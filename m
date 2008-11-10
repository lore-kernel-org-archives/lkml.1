Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbYKJXHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbYKJXHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 18:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbYKJXHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 18:07:09 -0500
Received: from outbound-mail-09.bluehost.com ([69.89.17.209]:56085 "HELO
	outbound-mail-09.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750811AbYKJXHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 18:07:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=MdlZG2WcFOlHdEDd8ZMyefR7UNm29LsomwBjwXLU9Q24s0lkS+wuplL9O1VUKSg0vP1zZG6GZ49iH6lGz8nJVsHH7bK/lgazJz8u6R84D6sU1JMgSHa9McCF8keq68aC;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Mathieu Chouquet-Stringer" <mchouque@free.fr>
Subject: Re: Suspend to disk broken in latest 2.6.28-rc3
Date: Mon, 10 Nov 2008 15:06:52 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.26.6-79.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
References: <20081109195033.GA1335@mobydick> <20081110094239.GA14204@atrey.karlin.mff.cuni.cz> <20081110221343.GA17951@mobydick>
In-Reply-To: <20081110221343.GA17951@mobydick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811101506.53324.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 10, 2008 2:13 pm Mathieu Chouquet-Stringer wrote:
> On Mon, Nov 10, 2008 at 10:42:39AM +0100, Pavel Machek wrote:
> > Trying with minimum drivers is likely to help here, and should be
> > easier than bisect. Boot with init=/bin/bash, then try "devices" >
> > pm_dest and disk > state...
>
> Some progress with (2.6.28-rc4 this time)...  I've booted with /bin/bash
> as init: works.
>
> Then I rebooted in single mode => works
> Runlevel 3 => works
> Runlevel 5 => doesn't work
>
> In terms of devices, lsmod says the only differences between runlevel 3
> and runlevel 5 are that both drm and radeon are loaded...
>
> If I rmmod radeon and drm while X is running suspending the devices
> works...  I guess I don't have DRI enabled???  Just looked at the logs,
> I guess I don't [1]...
>
> Looking at a git log -p of gpu/drm/radeon shows lots of difference
> between 2.6.26 and HEAD...  I see a vblank change [2] that changes the
> way the device is suspended, not sure if it really matters though...
>
> Alex, Jesse and/or Dave can you think of anything before I bisect?  FYI
> my radeon is a:
> ATI Technologies Inc Radeon Mobility M7 LW [Radeon Mobility 7500] rev 0,

If you have radeon loaded but DRI was never enabled, you'll likely see a 
crash.  That's because the radeon driver doesn't map the registers it needs 
for suspend/resume at load time; they only get mapped by DRI initialization 
code which lives in the X driver.  There's a patch in 
http://bugzilla.kernel.org/show_bug.cgi?id=11891 that might help you...

-- 
Jesse Barnes, Intel Open Source Technology Center

