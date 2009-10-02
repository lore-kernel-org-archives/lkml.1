Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZJBL5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZJBL5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 07:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbZJBL5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 07:57:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:58978 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbZJBL5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 07:57:10 -0400
Message-ID: <4AC5EA67.1080806@kernel.org>
Date: Fri, 02 Oct 2009 20:56:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: blp@cs.stanford.edu
CC: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 10/19] workqueue: update cwq alignement and make one more
 flag bit available
References: <1254384558-1018-11-git-send-email-tj@kernel.org>	<1254384558-1018-1-git-send-email-tj@kernel.org>	<10133.1254402320@redhat.com> <87zl8bhs0s.fsf@blp.benpfaff.org>
In-Reply-To: <87zl8bhs0s.fsf@blp.benpfaff.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 02 Oct 2009 11:56:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Restoring cc list.  Please don't drop them)

Ben Pfaff wrote:
> David Howells <dhowells@redhat.com> writes:
> 
>> Tejun Heo <tj@kernel.org> wrote:
>>
>>> +enum {
>>> +	WORK_STRUCT_PENDING	= 0,	/* work item is pending execution */
>>> +
>>> +	/*
>>> +	 * Reserve 3bits off of cwq pointer.  This is enough and
>>> +	 * provides acceptable alignment on both 32 and 64bit
>>> +	 * machines.
>>> +	 */
>>> +	WORK_STRUCT_FLAG_BITS	= 3,
>>> +
>>> +	WORK_STRUCT_FLAG_MASK	= (1UL << WORK_STRUCT_FLAG_BITS) - 1,
>>> +	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
>>> +};
>> There's some great enum abuse going on here:-)
> 
> The "1UL" part is a bit worrisome.  Enumeration constants always
> have type "int"[*], so if code that uses WORK_STRUCT_WQ_DATA_MASK
> actually depends on getting a full "long" worth of bits, it is
> not going to work on 64-bit systems.
> 
> [*] See C99:
> 
>      6.4.4.3 Enumeration constants
>      Syntax
> 1              enumeration-constant:
>                       identifier
>      Semantics
> 2    An identifier declared as an enumeration constant has type int.

Aieee... oops.  Well, this isn't how gcc behaves.

  $ cat test.c
  #include <stdio.h>

  enum {
	  ENUM		= ~0U,
  };

  enum {
	  LONG_ENUM	= ~0UL,
  };

  int main(void)
  {
	  printf("%zu %zu\n", sizeof(ENUM), sizeof(LONG_ENUM));
	  return 0;
  }
  $ gcc test.c && ./a.out; gcc -std=c99 test.c && ./a.out
  4 8
  4 8

But, yeah, this definitely is a problem.  6.7.2.2 also says that

 Each enumerated type shall be compatible with char, a signed integer
 type, or an unsigned integer type. The choice of type is
 implementation-defined,113) but shall be capable of representing the
 values of all the members of the enumeration. The enumerated type is
 incomplete until after the } that terminates the list of enumerator
 declarations.

gcc probably is being a bit too generous with possible integer types
here.  BTW, does c++ define it like this too?

Hmmm... So, should we go back to using defines for these or keep
(ab)using gcc's generousity and maybe hope the next iteration of the
standard to become a bit more generous too?

Thanks.

-- 
tejun
