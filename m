Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYKJPYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYKJPYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 10:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYKJPYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 10:24:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:25177 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbYKJPYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 10:24:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=i6qODQlWYAW+GhVi8goI9lWNzX0OGhnTk9+jTd+/wR7yWg2Cy2A6J3riUonCag3PqJ
         f9snMd3eJP6iooXml8MFQVaAo0SGDP97d4oWheoeIUQtXEQtdp3MbOGuB4GyLPZuIbQQ
         yg/uRITZhj+wed7bE+Ry+IyRMc7P97/4ZSXPo=
Message-ID: <7c86c4470811100724y1f61086co6ced2510383c5ae2@mail.gmail.com>
Date: Mon, 10 Nov 2008 16:24:10 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Paul Mackerras" <paulus@samba.org>
Subject: Re: [patch 00/24] perfmon3: introduction
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <18711.40796.201781.605269@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f8a9a3.0437560a.656a.57c5@mx.google.com>
	 <18711.40796.201781.605269@drongo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Mon, Nov 10, 2008 at 3:41 AM, Paul Mackerras <paulus@samba.org> wrote:
> Stephane,
>
> I have just looked through this set of patches and it mostly looks
> fine to me.  There is just one thing, and that is that the way you
> access bitmaps using cast_ulp() won't work on 32-bit big-endian
> machines such as 32-bit PowerPC.  I suggest that instead of using
> cast_ulp(), you have a set of abstracted bit-vector operations that
> can be implemented by the arch code - and on x86/ia64, they would be
> implemented with cast_ulp() + test_bit/__set_bit/etc. as at present.
>

Thanks for bringing this up. I think we had talked about this a while back.

There is indeed a problem on big endian 32-bit machines The cast will
pick up the wrong half of the u64. I think the best solution to this problem
is as you suggested. Consequently, I have added a perfmon abstraction (bv)
with its set of arch callbacks. The API takes u64 *.On x86, IA-64, it simply
calls the bitmap_*() API. On PPC, it will have to adjust when compiling for
32 bits.

Here is the example of __set_bit() on x86:

static inline void pfm_arch_bv_set_bit(int b, u64 *a)
{
        __set_bit(b, (unsigned long *)a);
}


I will push this into my linux-next tree and ask Stephen to pull from it again.
