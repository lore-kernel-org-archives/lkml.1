Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbYJJIEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbYJJIEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbYJJIE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:04:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53541 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbYJJIE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:04:26 -0400
Message-ID: <48EF0BFC.2090004@cn.fujitsu.com>
Date: Fri, 10 Oct 2008 16:02:04 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: remove 2 exported symbols
References: <48EC199D.40808@cn.fujitsu.com> <20081008024325.GA29227@Krystal> <48EC2377.6020706@cn.fujitsu.com> <20081008035325.GA31788@Krystal> <48ED6A29.3080903@cn.fujitsu.com> <20081009142758.GE15553@Krystal>
In-Reply-To: <20081009142758.GE15553@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> See my comment in marker.h :
> 
>  * @args: variable argument list pointer. Use a pointer to overcome C's
>  *        inability to pass this around as a pointer in a portable manner in
>  *        the callee otherwise.
> 
> It's an information hard to find on the web (cannot find my original
> source anymore, it's mainly through forums saying that the
> http://c-faq.com/varargs/handoff.html _doesn't_ work), but you'll
> understand that promotion of array to pointer when passed to a function
> poses problem when you try to pass this array to another function. The
> following won't work on architectures where va_list is defined as an
> array :
> 
> void C(const char *fmt, va_list argp)
> {
>   ....
> }
> 
> void B(const char *fmt, va_list argp)
> {
>   C(fmt, argp);  <--- this won't work, because we try to pass a pointer
>                       to a function expecting an array.
> }
> 
> void A(const char *fmt, ...)
> {
>   va_list argp;
> 
>   argp = va_start(fmt);
>   B(fmt, argp);
>   va_end(argp);
> }
> 
> The way to permit it is to pass a pointer to argp instead :
> 
> void C(const char *fmt, va_list *argp)
> {
>   ....
> }
> 
> void B(const char *fmt, va_list *argp)
> {
>   C(fmt, argp);
> }
> 
> void A(const char *fmt, ...)
> {
>   va_list argp;
> 
>   argp = va_start(fmt);
>   B(fmt, &argp);
>   va_end(argp);
> }
> 
> Mathieu
>

Hi Mathieu,

I understood, and the comp.lang.c FAQ seems very authoritative.
but in the kernel source I found these:

asmlinkage int vprintk(const char *fmt, va_list args)
{
......
	printed_len += vscnprintf(printk_buf + printed_len,
				  sizeof(printk_buf) - printed_len, fmt, args);
.....
}


int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
{
	int i;

	i=vsnprintf(buf,size,fmt,args);
	return (i >= size) ? (size - 1) : i;
}

int vsnprintf(char *buf, size_t size, const char *fmt, va_list args);


Thanks, Lai


