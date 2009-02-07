Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbZBGMas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbZBGMas (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 07:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZBGMab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 07:30:31 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:46790 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbZBGMa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 07:30:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=BwHSfByOx6JbhL/3KVWWjbpSaF9LROxlJlzvw/z6rUKbr5lJRonWHw06APNMjKBlZB
         kSWTadbzsrAw3yo0vNrdqMJ9y0gCOV3bsl1vvdyz1uLgEPXJYtm3BNrz7NHdjeOC2I48
         2BfwatVb1EzKWUjroMgCfNxSI4qO7PNg0Hu/4=
Date: Sat, 7 Feb 2009 13:24:32 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: itvirta@iki.fi, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Soft lockup in sungem on Netra AC200 when switching interface
	up
Message-ID: <20090207122432.GA2822@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206.220101.239298299.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote, On 02/07/2009 07:01 AM:

> From: Ilkka Virta <itvirta@iki.fi>
> Date: Fri, 6 Feb 2009 13:29:02 +0200
> 
>> Looking at gem_do_start() and gem_open(), it seems that the only thing
>> done while opening the device after the request_irq(), is a call to
>> napi_enable().
>>
>> I don't know what the ordering requirements are for the
>> initialization, but I boldly tried to move the napi_enable() call
>> inside gem_do_start() before the link state is checked and interrupts
>> subsequently enabled, and it seems to work for me. Doesn't even break
>> anything too obvious...
>>
>> Any ideas on how this really should be fixed?
> 
> Actually your fix looks good, I'll apply this :-)

Alas it could be not enough. It seems this problem is caused by not
serving interrupts if napi is disabled. This patch added napi_enable()
on one path, but e.g. here:

static int gem_close(struct net_device *dev)
{
        struct gem *gp = netdev_priv(dev);

        mutex_lock(&gp->pm_mutex);

        napi_disable(&gp->napi);

        gp->opened = 0;
        if (!gp->asleep)
                gem_do_stop(dev, 0);
...

similar storm can happen if an interrupt is triggered just after
napi_disable().

Jarek P.
