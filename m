Return-Path: <linux-kernel-owner+w=401wt.eu-S1763126AbXK2VIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763126AbXK2VIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760442AbXK2VH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:07:58 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:45092 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbXK2VH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:07:57 -0500
Date: Thu, 29 Nov 2007 22:07:56 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Joe Perches <joe@perches.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Reduce stack used by lib/hexdump.c
In-Reply-To: <474F28EB.20608@oracle.com>
Message-ID: <Pine.LNX.4.64.0711292206450.3089@fbirervta.pbzchgretzou.qr>
References: <1196359724.22120.22.camel@localhost> 
 <20071129102400.dac158d8.randy.dunlap@oracle.com>  <1196361860.22120.27.camel@localhost>
  <474F0A68.1080809@oracle.com> <1196369873.22120.69.camel@localhost>
 <474F28EB.20608@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 29 2007 13:02, Randy Dunlap wrote:
>> @@ -140,13 +140,20 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
>>   * Example output using %DUMP_PREFIX_ADDRESS and 4-byte mode:
>>   * ffffffff88089af0: 73727170 77767574 7b7a7978 7f7e7d7c  pqrstuvwxyz{|}~.
>>   */
>> +
>> +#define HEX_LINE_SIZE 200
>> +
>>  void print_hex_dump(const char *level, const char *prefix_str, int
>>  prefix_type,
>>     int rowsize, int groupsize,
>>     const void *buf, size_t len, bool ascii)
>>  {
>>   const u8 *ptr = buf;
>>   int i, linelen, remaining = len;
>> -	unsigned char linebuf[200];
>> +	unsigned char *linebuf;
>> +
>> +	linebuf = kmalloc(HEX_LINE_SIZE, GFP_KERNEL);
>> +	if (!linebuf) {
>> +		WARN_ON(1);
>> +		return;
>> +	}
>>  

I'd add GFP_ATOMIC here. Who knows whether tomorrow, the oops dumper
or warn_on will use print_hex_dump.
