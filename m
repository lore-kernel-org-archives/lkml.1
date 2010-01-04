Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513Ab0ADOoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab0ADOoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 09:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484Ab0ADOoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 09:44:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:46308 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab0ADOon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 09:44:43 -0500
Message-ID: <4B41FED9.1060601@suse.cz>
Date: Mon, 04 Jan 2010 15:44:41 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Roland Dreier <rdreier@cisco.com>, Sergei Trofimovich <slyich@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Sergei Trofimovich <slyfox@inbox.ru>
Subject: Re: [PATCH] Kbuild: set LC_MESSAGES=C (as LC_CTYPE=C is)
References: <1261761235-9431-1-git-send-email-slyfox@inbox.ru>	<4B354C70.1060109@zytor.com> <adar5qizg6w.fsf@roland-alpha.cisco.com> <4B366C69.9010700@zytor.com>
In-Reply-To: <4B366C69.9010700@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.12.2009 21:04, H. Peter Anvin wrote:
> On 12/25/2009 05:17 PM, Roland Dreier wrote:
>>
>>  > The whole reason with only setting some LC_* to C was to be able to
>>  > leave LC_MESSAGES intact, but it seems it breaks on too many real-life
>>  > systems.
>>
>>  > As such, I suggest we should set LC_ALL=C and get rid of the rest of it:
>>
>> Seems unfortunate to lose localized error messages.  (Although in my
>> en_US.UTF-8 case, all I get is non-ASCII quote characters)
>>
>> This all started because of the awk invocation in arch/x86/lib.  Maybe
>> the best idea would be to confine the locale monkeying to that one
>> place?
>>
> 
> It is also possible that setting only LC_COLLATE will solve the most
> fundamental problem, which is the one of character ranges.  LC_COLLATE
> probably will interfere less with LC_MESSAGES than the setting of LC_CTYPE.

We need LC_COLLATE=C so that [a-z] really means lowercase ASCII letters
and nothing else (most importantly not uppercase letters) in awk, sed
and the shell. If we stay with LC_CTYPE=$userdefined, the meaning of
[[:classes:]] becomes indeterministic and so does the mapping of
lowercase and uppercase characters:

$ echo iI | LC_CTYPE=tr_TR.UTF-8 awk '{ print $0 " " toupper($0) " "
tolower($0) }'
iI İI iı

Character classes are probably not a big issue (modulo the fact that
mawk doesn't seem to support them), because the input is ascii text
anyway. Regarding the tolower()/toupper() functions, I found one
potential troublemaker:

$ git grep -E 'to(lower|upper)' | grep -v '\.[ch]:'
arch/sh/tools/gen-mach-types:            tolower(mach[i]), mach[i]);

Maybe this awk script should be run with LC_ALL=C, people mostly care
about (localized) messages from gcc, not from awk.

Michal
