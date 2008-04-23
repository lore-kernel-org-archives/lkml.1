Return-Path: <linux-kernel-owner+w=401wt.eu-S1751765AbYDWGgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbYDWGgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 02:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYDWGf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 02:35:57 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:42125 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYDWGfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 02:35:55 -0400
Message-Id: <480EF4F6.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 23 Apr 2008 07:36:06 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] move BUG_TABLE into RODATA
References: <480E1BEE.76E4.0078.0@novell.com>
 <20080422180732.GA27222@uranus.ravnborg.org>
In-Reply-To: <20080422180732.GA27222@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Sam Ravnborg <sam@ravnborg.org> 22.04.08 20:07 >>>
>Hi Jan.
>
>> --- linux-2.6.25/arch/x86/kernel/vmlinux_64.lds.S	2008-04-17 04:49:44.000000000 +0200
>> +++ 2.6.25-bug-table-rodata/arch/x86/kernel/vmlinux_64.lds.S	2008-03-04 11:14:13.000000000 +0100
>> @@ -19,7 +19,7 @@ PHDRS {
>>  	data PT_LOAD FLAGS(7);	/* RWE */
>>  	user PT_LOAD FLAGS(7);	/* RWE */
>>  	data.init PT_LOAD FLAGS(7);	/* RWE */
>> -	note PT_NOTE FLAGS(4);	/* R__ */
>> +	note PT_NOTE FLAGS(0);	/* ___ */
>>  }
>
>Is this intentional in this patch?

Yes. While it may be possible to do this separately, it seemed safer to
me to keep it together since I only tested it this way.

>>  SECTIONS
>>  {
>> @@ -40,16 +40,14 @@ SECTIONS
>>  	_etext = .;		/* End of text section */
>>    } :text = 0x9090
>>  
>> +  NOTES :text :note
>> +
>>    . = ALIGN(16);		/* Exception table */
>>    __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
>>    	__start___ex_table = .;
>>  	 *(__ex_table)
>>    	__stop___ex_table = .;
>> -  }
>> -
>> -  NOTES :text :note
>> -
>> -  BUG_TABLE :text
>> +  } :text = 0x9090
>
>And I do not see the 0x9090 justified.
>Is this something to do with the fact that 0x90 equals NOP on x86?

Yes, for consistency I think this ought to be repeated here - while
not strictly necessary (__ex_table is data, hence padding with
zeroes rather than NOPs would be fine), it seems more safe to have
it here so that we don't catch occasional linker bugs. Ultimately I
would think __ex_table should go into RODATA, too, which would
eliminate the question.

Jan

