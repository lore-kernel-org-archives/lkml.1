Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbZFQKs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbZFQKs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 06:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZFQKsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 06:48:20 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:43352 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZFQKsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 06:48:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=RsBaegVt64D3I9vAsaFu9MZRKvdJj7ugoO1RHFKBmAdrMRacwOcQuQas7BEpc8iQ3T
         /YWBiTT8ZZyeSk80TfhDdfzwCmunz5kWD2a0X+O1UR+dYcEy68OcThlhw2dVS/SlIU78
         g/VbHW/OtmeTo67LSepk6OtMLkQjEKvgLlRTw=
MIME-Version: 1.0
In-Reply-To: <2ab84cd80906170340w3ad8b938t64b6d0926b18daa4@mail.gmail.com>
References: <2ab84cd80906170340w3ad8b938t64b6d0926b18daa4@mail.gmail.com>
Date: Wed, 17 Jun 2009 18:42:14 +0800
Message-ID: <2ab84cd80906170342ta334955yc69a2648fa979979@mail.gmail.com>
Subject: surpring results of test_and_set_bit() and test_and_clear_bit() 
	functions in Linux-2.6.25 kernel at x86_64 architecture
From: qingbo yuan <yuanbor.maillist@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,all
I recently encountered a strange phenomenon about test_and_set_bit()
and test_and_clear_bit().
Here are the comments about these functions in Linux-2.6.25 kernel at
x86_64 architecture:

/**
 * test_and_set_bit - Set a bit and return its old value
 */

/**
 * test_and_clear_bit - Clear a bit and return its old value
 */

According to the comments, if the old value is '0', then these
functions will return 0 to the caller, and
if the old value is '1', then these functions will return 1. However,
in my experiment, if the old value is '1', I got -1 instead of 1. Here
is the code:

void generos_test_bitmap(void)
{
 int cur,ret_clear,ret_set;
 unsigned long bitmap =0x3721;
 for(cur = find_first_bit(&bitmap,BITS_PER_LONG);cur <
BITS_PER_LONG;cur = find_next_bit(&bitmap, BITS_PER_LONG, cur + 1)){
  ret_clear  = test_and_set_bit(cur, &bitmap);
  ret_set  = test_and_clear_bit(cur, &bitmap);
  printk("test_and_set bit [%d] ret [%d]\n",cur,ret_set);
  printk("test_and_clear bit [%d] ret [%d]\n\n\n",cur,ret_clear);
 }
}

And here is the results:
test_and_set bit [0] ret [-1]
test_and_clear bit [0] ret [-1]
test_and_set bit [5] ret [-1]
test_and_clear bit [5] ret [-1]
test_and_set bit [8] ret [-1]
test_and_clear bit [8] ret [-1]
test_and_set bit [9] ret [-1]
test_and_clear bit [9] ret [-1]
test_and_set bit [10] ret [-1]
test_and_clear bit [10] ret [-1]
test_and_set bit [12] ret [-1]
test_and_clear bit [12] ret [-1]
test_and_set bit [13] ret [-1]
test_and_clear bit [13] ret [-1]

Interesting! Let's take a look at the definition of these funtions in
Linux-2.6.25:
 static inline int test_and_set_bit(int nr, volatile void *addr)
{
 int oldbit;
 asm volatile(LOCK_PREFIX "bts %2,%1\n\t"
       "sbb %0,%0"
       : "=r" (oldbit), ADDR
       : "Ir" (nr) : "memory");
 return oldbit;
}

static inline int test_and_clear_bit(int nr, volatile void *addr)
{
 int oldbit;
 asm volatile(LOCK_PREFIX "btr %2,%1\n\t"
       "sbb %0,%0"
       : "=r" (oldbit), ADDR
       : "Ir" (nr) : "memory");
 return oldbit;
}

1. bts and btr set/clear the bit and copy the old value to CF flag.
2. sbb %0,%0 equals (%0-(%0+CF)) -> %0
3. %0 -> oldbit

So, if the old bit is '0', these functions return 0;
      if the old bit is '1', these functions return -1;
Both of these functions were right if the comments modified as
"test_and_set_bit - Set a bit and return its opposite old value".

Can anybody point out what problems exist in my analysis?
