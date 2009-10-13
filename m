Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbZJMLge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbZJMLge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759508AbZJMLge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:36:34 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:43867 "EHLO
	QMTA10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759507AbZJMLgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:36:33 -0400
Message-ID: <4AD4661A.8090905@xyzw.org>
Date: Tue, 13 Oct 2009 04:35:54 -0700
From: Brian Rogers <brian@xyzw.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: tim.gardner@canonical.com, stable <stable@kernel.org>
CC: kernel-team@lists.ubuntu.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org
Subject: Bluetooth input fixes for stable
References: <4AD284F1.7050605@xyzw.org> <4AD3DCAF.7050908@canonical.com>
In-Reply-To: <4AD3DCAF.7050908@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Gardner wrote:
> Brian Rogers wrote:
>   
>> For Karmic's kernel, I recommend the following cherry-picks from upstream:
>>
>> 364f63519d94442ed373ac7da79033c8282df46a
>> 9eba32b86d17ef87131fa0bce43c614904ab5781
>> edad63886993d18ab800c49f6587a93432ef8b35
>>
>> They ensure Bluetooth input devices such as keyboards and mice are 
>> removed completely and in proper order when they disconnect, so that HAL 
>> sees the removal and relays the info to X. Without this, disconnected 
>> Bluetooth devices are left in X, and duplicates appear on each 
>> reconnection until the input device limit is hit. Then no newly 
>> connected input devices will work.
>>
>> Brian
>>     
>
> These look suitable for 2.6.31 stable. Have you sent them to
> stable@kernel.org?
>   

Actually, I hadn't sent these to stable yet, but that's a good idea. 
CCing relevant parties.

It's not actually a regression (or at least not a recent one) since the 
stale input device problem has existed as far back as I can remember, 
but these commits do 'fix a real bug that bothers people', as the 
guideline states, so I guess it's appropriate for stable.

Commit messages below:

commit 364f63519d94442ed373ac7da79033c8282df46a
Author: Marcel Holtmann <marcel@holtmann.org>
Date:   Sat Aug 22 14:15:53 2009 -0700

    Bluetooth: Disconnect HIDRAW devices on disconnect

    Currently the HID subsystem will create HIDRAW devices for the transport
    driver, but it will not disconnect them. Until the HID subsytem gets
    fixed, ensure that HIDRAW and HIDDEV devices are disconnected when the
    Bluetooth HID device gets removed.

    Based on a patch from Brian Rogers <brian@xyzw.org>

    Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

commit 9eba32b86d17ef87131fa0bce43c614904ab5781
Author: Marcel Holtmann <marcel@holtmann.org>
Date:   Sat Aug 22 14:19:26 2009 -0700

    Bluetooth: Add extra device reference counting for connections

    The device model itself has no real usable reference counting at the
    moment and this causes problems if parents are deleted before their
    children. The device model itself handles the memory details of this
    correctly, but the uevent order is not consistent. This causes various
    problems for systems like HAL or even X.

    So until device_put() does a proper cleanup, the device for Bluetooth
    connection will be protected with an extra reference counting to ensure
    the correct order of uevents when connections are terminated.

    This is not an automatic feature. Higher Bluetooth layers like HIDP or
    BNEP should grab this new reference to ensure that their uevents are
    send before the ones from the parent device.

    Based on a report by Brian Rogers <brian@xyzw.org>

    Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

commit edad63886993d18ab800c49f6587a93432ef8b35
Author: Marcel Holtmann <marcel@holtmann.org>
Date:   Sat Aug 22 14:22:15 2009 -0700

    Bluetooth: Let HIDP grab the device reference for connections

    The core exports the hci_conn_hold_device() and hci_conn_put_device()
    functions for device reference of connections. Use this to ensure that
    the uevents from the parent are send after the child ones.

    Based on a report by Brian Rogers <brian@xyzw.org>

    Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

