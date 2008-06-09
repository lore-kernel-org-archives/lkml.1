Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbYFIE4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbYFIE4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 00:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYFIE43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 00:56:29 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:24084 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbYFIE42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 00:56:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=BLJto86sGN63rFWxjwA2nog/LzADvSSbh9Q32EEk6eczcoSsYDhQDMpXqbkFsl5hlu
         jQv/qggr1H9/AWKzrGy8WBH418snBAmbf3Aq0/Gk2I3RPq+c6xaLD7hVte/cdro5QOLM
         KFaDVhn2NGuDdtXFs8n3XNXEphy7u9dxC7gvY=
Message-ID: <484CB7F5.7060606@gmail.com>
Date: Mon, 09 Jun 2008 13:56:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
References: <20080528143857.GB5585@homac.suse.de> <4845886E.2010505@garzik.org> <20080603181346.GA5013@srcf.ucam.org> <484C8AE1.3010908@gmail.com> <20080609014818.GA32083@srcf.ucam.org>
In-Reply-To: <20080609014818.GA32083@srcf.ucam.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Mon, Jun 09, 2008 at 10:44:01AM +0900, Tejun Heo wrote:
> 
>> TF-based ATA controllers are very sensitive to how the registers are 
>> accessed and sometimes lock up the whole machine when they are not happy 
>> by indefinitely holding the PCI bus.  This could have been the case if 
>> IOs were in flight when the dock event occurred.  Were they?
> 
> I'd stopped hal, so I can't imagine that userspace was causing any to be 
> generated at that point.

Ah... okay.  Stupid me.  libata EH always resets a frozen port to 
un-freeze it even if it's unoccupied to listen for hotplug events.  So, 
if dock notifies device removal after the actual device is gone && the 
port is frozen as a result, libata EH will try to reset the port after 
the device is gone and in this case the controller locks up the whole 
machine for that.  If schedule_eh is used, libata EH just removes the 
device and does nothing else and the controller is happy.

This isn't too safe tho.  There can be other things which can trigger 
port reset.  ie. hotplug request from userland, in-flight IOs at the 
time of dock removal, etc...  Maybe we need to implement a flag to 
indicate that the port is dead and shouldn't be accessed in any way.

Thanks.

-- 
tejun
