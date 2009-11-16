Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbZKPMWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbZKPMWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbZKPMWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:22:05 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:58251 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZKPMWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:22:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ZlljRmtz6JxaiQInf+dqkmdtDlUwIP5dPnS5RO3AAuOoMJQMtHRpGApR4ua/LM9OTJ
         1d7DLBWzZ1iLYjX7/D1i1TG9BafydwjnnAcY7f7S1fWvZW+vn/9Y4QdQLMu1OjC38F0J
         F9G6zStktk4SsNN7MbqJ1+PHABHBjIN7Vb12w=
MIME-Version: 1.0
In-Reply-To: <1258321890l.9645l.1l@oscar.alarsen.net>
References: <20091115200215.GA25351@machine> <1258321890l.9645l.1l@oscar.alarsen.net>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Mon, 16 Nov 2009 10:21:48 -0200
Message-ID: <b8bf37780911160421s3b79424doe82417f330414d72@mail.gmail.com>
Subject: Re: [PATCH v5 10/12] string: factorize skip_spaces and export it to 
	be generally available
To: Anders Larsen <al@alarsen.net>
Cc: Anonymous <aim0shei@lavabit.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Anders!

On Sun, Nov 15, 2009 at 7:51 PM, Anders Larsen <al@alarsen.net> wrote:
> On 2009-11-15 21:02:15, Anonymous wrote:
>>
>> On Sun, Nov 15, 2009 at 08:33:29PM +0100, Anders Larsen wrote:
>> > On 2009-11-15 08:15:03, André Goddard Rosa wrote:
>> > >+char *skip_spaces(const char *str)
>> > >+{
>> > >+    while (isspace(*str))
>> > >+            ++str;
>> > >+    return (char *)str;
>> > >+}
>> >> Is there a good reason why the parameter 'str' is declared 'const'
>> > when skip_spaces() returns a non-const pointer into str ?
>> >Declaring return value as const won't let us modificate string after
>> skipping spaces. Declaring parameter as non-const won't let us
>> giving (const char *) to this function. So i think it is ok.
>
> skip_spaces() _implicitly_ casts away the 'const' of the parameter,
> which may come as a (nasty) surprise to users of the function.
>
> Consider this (contrieved and buggy) example:
>
>        const char* my_string = " do not modify me! ";
>        char* result = strcat(skip_spaces(my_string, "boom!"));
>
> The proposed implementation of skip_spaces() effectively prevents
> the compiler from catching this obvious bug.
>

I agree with the above comment. It's possible to make it differently
char* skip_spaces(char *),
but it's necessary to change many of its callers at the same time:

CC      lib/argv_split.o
lib/argv_split.c: In function ‘count_argc’:
lib/argv_split.c:24: warning: passing argument 1 of ‘skip_spaces’
discards qualifiers from pointer target type
include/linux/string.h:65: note: expected ‘char *’ but argument is of
type ‘const char *’
lib/argv_split.c: In function ‘argv_split’:
lib/argv_split.c:78: warning: passing argument 1 of ‘skip_spaces’
discards qualifiers from pointer target type
include/linux/string.h:65: note: expected ‘char *’ but argument is of
type ‘const char *’
...
  CC      lib/vsprintf.o
lib/vsprintf.c: In function ‘vsscanf’:
lib/vsprintf.c:1737: warning: passing argument 1 of ‘skip_spaces’
discards qualifiers from pointer target type
include/linux/string.h:65: note: expected ‘char *’ but argument is of
type ‘const char *’
lib/vsprintf.c:1738: warning: passing argument 1 of ‘skip_spaces’
discards qualifiers from pointer target type
include/linux/string.h:65: note: expected ‘char *’ but argument is of
type ‘const char *’
lib/vsprintf.c:1808: warning: passing argument 1 of ‘skip_spaces’
discards qualifiers from pointer target type
include/linux/string.h:65: note: expected ‘char *’ but argument is of
type ‘const char *’
lib/vsprintf.c:1850: warning: passing argument 1 of ‘skip_spaces’
discards qualifiers from pointer target type
include/linux/string.h:65: note: expected ‘char *’ but argument is of
type ‘const char *’

    There are other functions following the same pattern presently:

        char *strstr(const char *haystack, const char *needle);
        char *strchr(const char *s, int c);
        char *strrchr(const char *s, int c);

    on both glibc and the kernel.

Thanks,
André
