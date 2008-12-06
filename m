Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbYLFSLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbYLFSLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 13:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYLFSKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 13:10:54 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:28087 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbYLFSKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 13:10:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dHflhtUGSOVYiGXcPQeeJ3rNdkyN88h2WD/Y+hSVrT9sqxZ1hPssU9cJd+G8X+08Mn
         oMmxilDroPqtfEtPvTksSzusGTDRcM/6BGctdL6uejFRjg4hrVtWYZZZF/hFfhI0ueOE
         cCycXZar+WiM20dfSTDzDGNRf6sjdf6+1usfI=
Message-ID: <35476bd20812061010g145b6c19r282ae32a4ebfabb1@mail.gmail.com>
Date: Sat, 6 Dec 2008 19:10:52 +0100
From: "m m" <olsajiri@gmail.com>
To: "Patrick McHardy" <kaber@trash.net>
Subject: Re: netlink - notify when the socket gets closed
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <493A92FD.3060302@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <35476bd20812050017y70c3c729v450cdc3d0c1188de@mail.gmail.com>
	 <20081205195624.95ea1866.akpm@linux-foundation.org>
	 <493A92FD.3060302@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 6, 2008 at 3:58 PM, Patrick McHardy <kaber@trash.net> wrote:
> Andrew Morton wrote:
>>
>> (cc netdev@vger.kernel.org)
>>
>> On Fri, 5 Dec 2008 09:17:51 +0100 "m m" <olsajiri@gmail.com> wrote:
>>>
>>> I'm using netlink in my module. Based on the communication,
>>> this module dynamically creates some internal structure, which
>>> needs to be destroyed when the user level socket is closed (or
>>> the application dies).
>>>
>>> I found I could use the netlink_register_notifier function to register
>>> NETLINK_URELEASE callback during the netlink_release function.
>>> But since my module uses the multicast netlink socket communication,
>>> it wont be called:
>>>
>>> [...]
>>> Whats the reason this callback is not called for multicast sockets?
>>>
>>> To workaround it I created simple misc device which the user application
>>> opens before creating the netlink socket. This way I get some callbacks
>>> inside the module when the application dies, at least.. pretty ugly :)
>>>
>>> Is there a netlink mechanism to be notified when the netlink socket is
>>> closed on the user level side? (when using multicast communication)
>>>
>>> Or is there any other design I could use, since I think I'm not alone in
>>> using internal module data which needs to be removed once the application
>>> dies.
>
>
> That doesn't make sense. When you use multicast, multiple applications
> can be listening to the messages. If you really need state for a single
> listener and exchange messages in both directions, it sounds like you
> should use unicast.
>
>

My user app register in kernel for a data. When there is a first
application request,
kernel module creates an internal record and ask DATA subsystem for a data,
which are then passed to the user application.

The data are then delivered to the application as they are comming from
the DATA subsystem.

When there's another application requesting the same data type, kernel module
just increase reference count in the internal record, and multicast delivers
data to the other app.

Now when one of those applications end, kernel module just decrease
the reference count in the internal record.

When the other application ends, kernel module needs to release the internal
record and ask the DATA subsystem to stop delivering data.

Hope this make sense... I could do some ascii art next time if needed :)

thanks,
jirka
