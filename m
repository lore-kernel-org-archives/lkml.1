Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbXFLQ4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbXFLQ4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 12:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbXFLQ4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 12:56:25 -0400
Received: from terminus.zytor.com ([192.83.249.54]:39989 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbXFLQ4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 12:56:24 -0400
Message-ID: <466ECF37.6040303@zytor.com>
Date: Tue, 12 Jun 2007 09:52:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Shani Moideen <shani.moideen@wipro.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@lists.osdl.org
Subject: Re: [KJ PATCH] Replacing memcpy(dest,src,PAGE_SIZE) with copy_page(dest,src)
 in arch/i386/kernel/machine_kexec.c
References: <1181616342.2282.8.camel@shani-win> <m1vedtpwks.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1vedtpwks.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Shani Moideen <shani.moideen@wipro.com> writes:
> 
>> Hi,
>> Replacing memcpy(dest,src,PAGE_SIZE) with copy_page(dest,src) in
>> arch/i386/kernel/machine_kexec.c.
> 
> Please no.
> 
> People get creative in copy_page (especially mmx_copy_page),
> and this code path need something simple and stupid, that
> will work every time, especially when things are messed up
> elsewhere.
> 

memcpy() is pretty creative, too.  If you want something really dumb and
robust, you should probably create an inline:

/*
 * Eric sez: his code path need something simple and stupid, that
 * will work every time, especially when things are messed up
 * elsewhere.
 */
static inline void braindead_copy_page(void *dst, void *src)
{
	unsigned long ctr = PAGE_SIZE >> 2;

	asm volatile("cld; rep; movsl"
			: "+D" (dst), "+S" (src), "+c" (ctr)
			: : "memory");
}

(FWIW, the "cld" is supposed to be redundant, as DF=0 is supposed to be
guaranteed by the ABI.)

	-hpa
