Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbYJMHUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbYJMHUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 03:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYJMHUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 03:20:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63098 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbYJMHUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 03:20:33 -0400
Message-ID: <48F2F620.9020305@cn.fujitsu.com>
Date: Mon, 13 Oct 2008 15:17:52 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Paul Jackson <pj@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] seq_file: don't call bitmap_scnprintf_len()
References: <48F1C36D.6080301@cn.fujitsu.com> <20081013063806.GB3596@x200.localdomain>
In-Reply-To: <20081013063806.GB3596@x200.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Sun, Oct 12, 2008 at 05:29:17PM +0800, Lai Jiangshan wrote:
>> "m->count + len < m->size" is true commonly, so bitmap_scnprintf()
>> is commonly called. this fix saves a call to bitmap_scnprintf_len().
> 
> This saves a call if seq buffer is already full which is not a common
> situation, so you're optimising for rare situations and adding branch
> for common ones.

Hi Alexey

I think this saves a call if seq buffer is _not_ full after called.

since calling bitmap_scnprintf() is the common situation. so we use
the return value of bitmap_scnprintf() instead of bitmap_scnprintf_len().

In old code bitmap_scnprintf_len() and bitmap_scnprintf() must be called
commonly.

Thanks Lai.

> 
>> --- a/fs/seq_file.c
>> +++ b/fs/seq_file.c
>> @@ -452,17 +452,18 @@ int seq_dentry(struct seq_file *m, struct dentry *dentry, char *esc)
>>  
>>  int seq_bitmap(struct seq_file *m, unsigned long *bits, unsigned int nr_bits)
>>  {
>> -	size_t len = bitmap_scnprintf_len(nr_bits);
>> -
>> -	if (m->count + len < m->size) {
>> -		bitmap_scnprintf(m->buf + m->count, m->size - m->count,
>> -				 bits, nr_bits);
>> -		m->count += len;
>> -		return 0;
>> +	if (m->count < m->size) {
>> +		int len = bitmap_scnprintf(m->buf + m->count,
>> +				m->size - m->count, bits, nr_bits);
>> +		if (m->count + len < m->size) {
>> +			m->count += len;
>> +			return 0;
>> +		}
>>  	}
>>  	m->count = m->size;
>>  	return -1;
>>  }
>> +EXPORT_SYMBOL(seq_bitmap);
> 
> Modular users, where are they?
> 
> 
> 


