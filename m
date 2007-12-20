Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbXLTKek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbXLTKek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 05:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXLTKec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 05:34:32 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:34862 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbXLTKea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 05:34:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QVGpoMPX2QI9IPD9pN4x619dnvIp+px13nF/SiwFWMKoOB+gczriCFEVsR38ESNSqNNrnUF4ywS4g4gzg0JqWGvqBfeyIk5gMEdMEqfPeEVNrOqygmJOR+CIeszKuOF+IpD9yzq5/uJ9Rrgw8fonCORJc8O7oU1JG6r2qSXkEl8=
Message-ID: <5d6222a80712200234t5129a0aes98e0f0869ad9c93c@mail.gmail.com>
Date: Thu, 20 Dec 2007 08:34:18 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [kvm-devel] Guest kernel hangs in smp kvm for older kernels prior to tsc sync cleanup
Cc: "Avi Kivity" <avi@argo.co.il>, "Ingo Molnar" <mingo@elte.hu>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Gerd Hoffmann" <kraxel@redhat.com>
In-Reply-To: <47693B9D.7080809@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47680173.6060606@qumranet.com> <20071218221930.GA26109@elte.hu>
	 <4768BB43.1000609@qumranet.com> <4768FE27.7020305@qumranet.com>
	 <47690304.1090903@qumranet.com> <20071219140624.GF21282@elte.hu>
	 <47692A47.4040803@argo.co.il>
	 <5d6222a80712190732h515a63e6y49c64c0f572f044@mail.gmail.com>
	 <47693B9D.7080809@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 19, 2007 1:41 PM, Avi Kivity <avi@qumranet.com> wrote:
> Glauber de Oliveira Costa wrote:
> > Changes in rate does not sound good. It's possibly what's screwing up
> > my paravirt clock implementation in smp.
> >
>
> You should renew the timebase on vcpu migration, and hook cpufreq so
> that changes in frequency are reflected in the timebase.

 To be conservative, I do it in every vcpu run, and have any kind of
cpu frequency scaling disabled. And it does not work.

In a trace in the host, I see that vcpu runs happens very often in
vcpu 0 (probably because exits happen often there, so we have to go
back),
and comparatively, very few times in vcpu 1.

So what's probably happening is : vcpu 1 does system_time + tsc_delta,
 but vcpu 0 has already updated it so many times, the tsc does not
keep up,
and it end going backwards.

I'm running (in the host), the following test, upon module loading
(and Ingo can please tell me if I'm doing something idiotic in it,
compromising my conclusions)

void test (int foo)
{
       u64 start, stop;
       start = native_read_tsc();
       udelay(foo);
       stop = native_read_tsc();
       printk("%d Result: %lld\n", foo, foo * 1000 - cycles_2_ns(stop
- start));
}

Output is:

30 Result: -126
90 Result: 576
300 Result: 2627
1000 Result: 9381
3000 Result: 28238
5000 Result: 48086


So the delta is expecting to get bigger. If a vcpu passes a long time
without having the time updated.
Xen manages to keep the guest tsc stable and steady by doing
synchronization from time to time.

We can either: (If I'm right at this, of course):

* put a periodic timer in the host to update the system time from time to time;
* use some sort of global timestamp, instead of the per-cpu one.
* do something akin to what xen does, and still rely on the tsc.

Any thoughts?
-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
