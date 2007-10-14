Return-Path: <linux-kernel-owner+w=401wt.eu-S1763103AbXJNStV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763103AbXJNStV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbXJNStK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:49:10 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:9984 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbXJNStI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:49:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=WEOCH8efAOgL7w+vcWXjBfGvbij4pvq/jLO7f9Mzi4xDntk1wY2UJe02oMHEpIRPjdp25S7IdDze/9rcug5LDA/xihyYPKCC0daMVJ3IlCa+zvdrgBb4rR1QlpKAqqyyM47U5i7fBv5gc5pviRpOVHc1+l9P6iOfPbs9F3YbXdU=
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: drivers/net/wireless/rt2x00/: struct data_desc strangeness
Date: Sun, 14 Oct 2007 21:06:20 +0200
User-Agent: KMail/1.9.7
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071014175032.GI4211@stusta.de>
In-Reply-To: <20071014175032.GI4211@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710142106.20409.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2007, Adrian Bunk wrote:
> drivers/net/wireless/rt2x00/rt2x00ring.h contains the following:
> 
> <--  snip  -->
> 
> ...
> /*
>  * data_desc
>  * Each data entry also contains a descriptor which is used by the
>  * device to determine what should be done with the packet and
>  * what the current status is.
>  * This structure is greatly simplified, but the descriptors
>  * are basically a list of little endian 32 bit values.
>  * Make the array by default 1 word big, this will allow us
>  * to use sizeof() correctly.
>  */
> struct data_desc {
>         __le32 word[1];
> };
> ...
> /*
>  * TX/RX Descriptor access functions.
>  */
> static inline void rt2x00_desc_read(struct data_desc *desc,
>                                     const u8 word, u32 *value)
> {
>         *value = le32_to_cpu(desc->word[word]);
> }
> 
> static inline void rt2x00_desc_write(struct data_desc *desc,
>                                      const u8 word, const u32 value)
> {
>         desc->word[word] = cpu_to_le32(value);
> }
> ...
> 
> <--  snip  -->
> 
> I haven't checked whether it might work in all cases, but passing 
> non-zero values as second parameter to rt2x00_desc_{read,write}()
> (as is done in many cases) is even in the best case bad coding style.

Access to the array is correct, even with non-zero values the code that is
reading/writing to the array knows the exact size of the descriptor. Within
rt2x00 are however 5 drivers who have different descriptor sizes. That means
I can't create a structure which has the correct array length.

The structure itself is just a simple map over preallocated memory
(skb->data in case of USB or dma in case of PCI).

So possible solutions would be:
 - remove struct data_desc and make it a void* or __le32*
   This is at the cost of code readibility since the above pointers
   have less meaning then a pointer to a structure which can be nicely
   documented.
 - increase the word[] array to something that fits all (+/- 20 entries)
   This wouldn't really be a problem, all it requires is fixing the sizeof() 
   statements. But then the code should contain a big note about that it
   is not allowed to read/write _all_ words in the entry since it depends on
   the driver that uses it.

What would in this case be the best solution for good coding style?

Ivo
