Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbZFDPMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbZFDPMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZFDPMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:12:10 -0400
Received: from stinky.trash.net ([213.144.137.162]:34559 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZFDPMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:12:09 -0400
Message-ID: <4A27E448.3040305@trash.net>
Date: Thu, 04 Jun 2009 17:12:08 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       sfr@canb.auug.org.au, slapin@ossfans.org
Subject: Re: [PATCH 4/6] net: add NL802154 interface for configuration of
 	802.15.4 devices
References: <1244021629-18409-4-git-send-email-dbaryshkov@gmail.com>	 <1244021629-18409-5-git-send-email-dbaryshkov@gmail.com>	 <1244021964.10665.5.camel@johannes.local>	 <20090603.030911.162861804.davem@davemloft.net>	 <20090603105256.GB20508@doriath.ww600.siemens.net>	 <1244027110.1693.9.camel@johannes.local>	 <20090603122744.GC20508@doriath.ww600.siemens.net>	 <1244124749.22576.71.camel@johannes.local> <bc64b4640906040751i3c64c317i4eedb7d53307092a@mail.gmail.com>
In-Reply-To: <bc64b4640906040751i3c64c317i4eedb7d53307092a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Eremin-Solenikov wrote:
> 2009/6/4 Johannes Berg <johannes@sipsolutions.net>:
>> On Wed, 2009-06-03 at 16:27 +0400, Dmitry Eremin-Solenikov wrote:
>>
>>>>> +static int ieee802154_nl_put_failure(struct sk_buff *msg)
>>>>> +{
>>>>> + void *hdr = genlmsg_data(NLMSG_DATA(msg->data)); /* XXX: nlh is right at the start of msg */
>>>>> + genlmsg_cancel(msg, hdr);
>>>>> + nlmsg_free(msg);
>>>>> + return -ENOBUFS;
>>>>> +}
>>>> This seems weird.
>>> Why?
>> Because it's strange to cancel then free?
> 
>>From looking at the other code, the usual pattern for netlink is
> (please, correct me if I'm wrong):
> 
> int fill (....)
> {
>    genlmsg_put();
>    NLA_PUT(...)
>    NLA_PUT(...)
>    return genlmsg_end();
> 
> nla_put_failure:
>    genlmsg_cancel();
>    return -EMSGSIZE;
> }
> 
> int cmd(...)
> {
>     int rc;
>     nlmsg_new();
> 
>     rc = fill();
>     if (rc < 0)
>         goto out;
> 
>     genlmsg_unicast();
> 
> out:
>     nlmsg_free();
>     return -ENOBUFS;
> }
> 
> This is equivalent to our code:
> 
> sk_buff *new()
> {
>    msg = nlmsg_new();
>    genlmsg_put();
>    return msg;
> }

canceling messages is only necessary in fill functions that are
also used for dumps, where as many elements are stuffed in the
skb as possible. When the last element doesn't completely fit,
its removed again (canceled) and put into the next skb.

