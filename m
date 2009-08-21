Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbZHUIs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbZHUIs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 04:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbZHUIsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 04:48:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:50929 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbZHUIsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 04:48:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=d8687nZM6s10doF8I25LzldKv7000G59PnlSxP3iqYIvVT6K1aMTxXNZvcPEnf6/UV
         0xNFgdFcMzG6IKeZ17MBtFKLefJ56OQiK0CJvTExd5c1kzCAgT3aVcNgzfdKj5WB89nG
         poEsEl/ETTfqENqlqNH0SVusYO36Bir6fo9Bs=
Message-ID: <4A8E5F73.6010904@gmail.com>
Date: Fri, 21 Aug 2009 10:48:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-7.5 Thunderbird/3.0b3
MIME-Version: 1.0
To: Amerigo Wang <xiyou.wangcong@gmail.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Nicolas Palix <npalix@diku.dk>, linux-kernel@vger.kernel.org,
       Yoann Padioleau <yoann.padioleau@gmail.com>,
       Julia Lawall <julia@diku.dk>, Joe Perches <joe@perches.com>,
       devel@driverdev.osuosl.org, akpm@linux-foundation.org
Subject: Re: [PATCH v2] scripts: add typdef removal tool
References: <1250228384-19823-1-git-send-email-lrodriguez@atheros.com> <20090817060203.GL5039@cr0.nay.redhat.com>
In-Reply-To: <20090817060203.GL5039@cr0.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 08/17/2009 08:02 AM, Amerigo Wang wrote:
...
>> --- /dev/null
>> +++ b/scripts/remove-typedef
>> @@ -0,0 +1,70 @@
>> +#!/bin/bash
>> +#
>> +# Copyright 2009 Joe Perches <joe@perches.com>
>> +# Copyright 2009 Luis R. Rodriguez <mcgrof@gmail.com>
>> +#
>> +# Lets you remove typedefs from C/header files.
>> +#
>> +# We do simple sed substituation for logical places where you would

substitution

>> +function remove_typedef()
>> +{
>> +	if [ ! -f $1 ]; then
>> +		return;
>> +	fi
>> +
>> +	# This replaces the typedef usages with simple structs
>> +	sed -r -i -e "s/\b$from\b/struct $to/g" $1
>> +	sed -r -i -e "s/\bP$from\b/struct $to \*/g" $1
>> +	sed -r -i -e "s/struct $to\s*\*\s*\b/struct $to \*/g" $1
>> +	sed -r -i -e "s/\(struct $to\s*\*\)\s*/\(struct $to \*\)/g" $1

Could that be one sed with multiple -e's?

>> +	# This replaces the typedef declaration for a simple struct declaration - style 0
>> +	perl -i -e "local $/; while(<>) { s/\btypedef\s+struct\s+([\d\D]+?)\s*\{([\d\D]+?)\}\s*struct\s+$to\b[^;]*;/struct $to \{\2\};/g; print; }" $1

This is safe until bash devs start to use $/ as something. It should be
escaped.

>> +	# This replaces the typedef declaration for a simple struct declaration - style 1
>> +	perl -i -e "local $/; while(<>) { s/\btypedef\s+struct\s+_$from\s*\{([\d\D]+?)\}\s*struct\s+$to\b[^;]*;/struct $to \{\1\};/g; print; }" $1
>> +
>> +	# This replaces the typedef declaration for a simple struct declaration - style 2
>> +	perl -i -e "local $/; while(<>) { s/\btypedef\s+struct\s+$to\s*\{([\d\D]+?)\}\s*$from\b[^;]*;/struct $to \{\1\};/g; print; }" $1

And possibly one
perl -ipe "BEGIN { \$/ = '' };
	s/x/y/g;
	s/y/z/g;"
?

Or do the sed work by perl too?

>> +}
>> +
>> +if [[ $# -lt 3 ]]; then

Could that be [ ] instead of [[ ]]?

>> +	usage
>> +fi
>> +
>> +from=$1
>> +to=$2
>> +shift
>> +echo "Converting typedef $from to struct $to"
>> +
>> +while shift; do
>> +	REM_PATH=$1
>> +
>> +	if [ -z $REM_PATH ]; then
>> +		continue;
>> +	fi
>> +
>> +	if [ ! -d $REM_PATH ]; then
>> +		echo "No directory $REM_PATH";
>> +		continue;
>> +	fi
>> +
>> +	for i in $(find $REM_PATH -type f -name *.c); do
>> +		remove_typedef $i
>> +	done
>> +
>> +	for i in $(find $REM_PATH -type f -name *.h); do
>> +		remove_typedef $i
>> +	done
> 
> These two 'find's can be merged:
> 
>   find $REM_PATH -type f -name '*.c' -o -name '*.h'

Yes, please enclose those wildcards into ''. Also REM_PATH can be with
spaces, use "" for it, $i and $1 etc.
