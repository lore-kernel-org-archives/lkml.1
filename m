Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbXLFWDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbXLFWDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 17:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbXLFWD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 17:03:26 -0500
Received: from gw.goop.org ([64.81.55.164]:37261 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbXLFWDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 17:03:25 -0500
Message-ID: <475871A9.5050707@goop.org>
Date: Thu, 06 Dec 2007 14:03:21 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <glommer@gmail.com>
CC: Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com
Subject: Re: [PATCH 1/19] unify desc_struct
References: <1196957800568-git-send-email-gcosta@redhat.com>	 <11969578092869-git-send-email-gcosta@redhat.com>	 <200712062154.40075.ak@suse.de> <5d6222a80712061320w1224fa10r1d15f214c7e45862@mail.gmail.com>
In-Reply-To: <5d6222a80712061320w1224fa10r1d15f214c7e45862@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> On Dec 6, 2007 6:54 PM, Andi Kleen <ak@suse.de> wrote:
>   
>>> +/*
>>> + * FIXME: Acessing the desc_struct through its fields is more elegant,
>>> + * and should be the one valid thing to do. However, a lot of open code
>>> + * still touches the a and b acessors, and doing this allow us to do it
>>> + * incrementally. We keep the signature as a struct, rather than an union,
>>> + * so we can get rid of it transparently in the future -- glommer
>>> + */
>>> +#define raw_desc_struct struct { unsigned int a, b; }
>>> +#define detailed_desc_struct                                   \
>>> +  struct {                                                       \
>>> +     u16 limit0;                                             \
>>> +     u16 base0;                                              \
>>> +     unsigned base1 : 8, type : 4, s : 1, dpl : 2, p : 1;    \
>>> +     unsigned limit : 4, avl : 1, l : 1, d : 1, g : 1, base2 :8;\
>>> +  }
>>>       
>> The standard clean way to do this is with a anonymous union.
>>     
> It is an anonymous union.
>
> However:
>
> * It's an union of structs
> * I wished to keep the toplevel type as a struct
> The alternative would be to write:
>
> struct desc_struct {
> union {
>     struct { unsigned int a, b; };
>     struct {
>                u16 limit0;
>                u16 base0;
>                unsigned base1 : 8, type : 4, s : 1, dpl : 2, p : 1;
>                unsigned limit : 4, avl : 1, l : 1, d : 1, g : 1, base2 :8;
>     };
> };
> };
>
> Which is fine, it's all the same in the end. Just with more shift
> rights, and more visual pollution.
>   

No, that's much clearer.  It's a pity that the anonymous struct/union
syntax isn't general enough to allow:

struct desc_packed {
               u16 limit0;
               u16 base0;
               unsigned base1 : 8, type : 4, s : 1, dpl : 2, p : 1;
               unsigned limit : 4, avl : 1, l : 1, d : 1, g : 1, base2 :8;
};

struct desc {
	struct desc_packed;
};

    J
