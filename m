Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbXJCIXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbXJCIXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbXJCIXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:23:06 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:12558 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbXJCIXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:23:03 -0400
Message-ID: <47035212.4000402@openvz.org>
Date: Wed, 03 Oct 2007 12:25:54 +0400
From: Kirill Korotaev <dev@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Kirill Korotaev <dev@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, cebbert@redhat.com, hpa@zytor.com,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH] mark read_crX() asm code as volatile
References: <470250E0.5090706@openvz.org> <20071002082856.3c478e66@laptopd505.fenrus.org>
In-Reply-To: <20071002082856.3c478e66@laptopd505.fenrus.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan,

I can experiment with any constraints if you suggest which one.

>From our experiments with gcc, it compares asm strings (sic!!!) to find matches
to be merged! Sigh...
Below are 2 programs which differ in one space in read_cr3_b() asm statement.
The first one compiles incorrectly, while 2nd one - correctly.

My personal feeling is that comparing asm strings is simply a "misfeature".

-------------------------- cut ----------------------------
static inline unsigned long read_cr3_a(void)
{
        unsigned long cr3;
        asm("movq %%cr3,%0" : "=r" (cr3));
        return cr3;
}

static inline unsigned long read_cr3_b(void)
{
        unsigned long cr3;
        asm("movq %%cr3,%0" : "=r" (cr3));
        return cr3;
}

static inline void write_cr3(unsigned long val)
{
        asm volatile("movq %0,%%cr3" :: "r" (val) : "memory");
}

void main()
{
        unsigned long c;
        c = read_cr3_a();
        write_cr3(c | 0x80);
        c = read_cr3_b();
        write_cr3(c | 0x100);
}
-------------------------- cut ----------------------------


-------------------------- cut ----------------------------
static inline unsigned long read_cr3_a(void)
{
        unsigned long cr3;
        asm("movq %%cr3,%0" : "=r" (cr3));
        return cr3;
}

static inline unsigned long read_cr3_b(void)
{
        unsigned long cr3;
        asm("movq  %%cr3,%0" : "=r" (cr3));
        return cr3;
}

static inline void write_cr3(unsigned long val)
{
        asm volatile("movq %0,%%cr3" :: "r" (val) : "memory");
}

void main()
{
        unsigned long c;
        c = read_cr3_a();
        write_cr3(c | 0x80);
        c = read_cr3_b();
        write_cr3(c | 0x100);
}
-------------------------- cut ----------------------------

Kirill

Arjan van de Ven wrote:
> On Tue, 02 Oct 2007 18:08:32 +0400
> Kirill Korotaev <dev@openvz.org> wrote:
> 
> 
>>Some gcc versions (I checked at least 4.1.1 from RHEL5 & 4.1.2 from
>>gentoo) can generate incorrect code with read_crX()/write_crX()
>>functions mix up, due to cached results of read_crX().
>>
> 
> 
> I'm not so sure volatile is the right answer, as compared to giving the
> asm more strict contraints....
> 
> asm volatile tends to mean something else than "the result has
> changed"....
> 
> 

