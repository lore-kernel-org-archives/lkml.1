Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbZHKM4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbZHKM4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbZHKM4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:56:46 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:43851 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZHKM4p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:56:45 -0400
MIME-Version: 1.0
In-Reply-To: <adad4738l3v.fsf@cisco.com>
References: <e2e108260908060943u344bbe03k2baab01b204c9cca@mail.gmail.com> 
	<adad478hmi8.fsf@cisco.com> <e2e108260908061146y47ae45f5j6b8085d44cd1c45b@mail.gmail.com> 
	<adaocqsg339.fsf@cisco.com> <e2e108260908061229v2c605aabp7cf66cbe568d6755@mail.gmail.com> 
	<adafxc4g1e7.fsf@cisco.com> <e2e108260908070026s10658adl2c4a9a5b3eba1a08@mail.gmail.com> 
	<20090808034817.GA30697@suse.de> <adad4738l3v.fsf@cisco.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 11 Aug 2009 14:56:28 +0200
Message-ID: <ac3eb2510908110556s44db5e24rba901cc4d4a4c431@mail.gmail.com>
Subject: Re: [ofa-general] IB kernel modules and the kobject release() method
To: Roland Dreier <rdreier@cisco.com>
Cc: Greg KH <gregkh@suse.de>, Bart Van Assche <bart.vanassche@gmail.com>,
       OpenIB <general@lists.openfabrics.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 22:33, Roland Dreier<rdreier@cisco.com> wrote:
>
>  > No, it still makes sense :)
>
> So what's the fix for this?

The fix is not to embed any kobject/struct device into an object whose
lifetime is not controlled by the kobject. The kobject should just be
a pointer then, and not inlined in the same memory the object uses,
which needs the kobject. The entire kobject embedding/release logic
works only properly if the kobject can own/control the lifetime of the
enclosing object - if not, it should just not be embedded.

> If even you have trouble understanding
> kobject lifetimes

I don't think we have trouble understanding that, but we are
hopelessly lost running after people who "optimize" the use of
kobjects/struct device to save an allocation or a separate dynamic
object.

> and the requirement for a release function, is there
> hope for anyone else?

Almost all uses where kobjects/struct device are statically allocated,
an object embeds more than a single kobject, or the embedded kobject
does not control the lifetime of the enclosing object, is just a
mis-use of kobjects.

Not sure, maybe it needs a simpler API to use non-embedded kobjects,
to make it easier to reach the originating object from the kobject.
That might not be obvious how to do that in some cases.

Kay
