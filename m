Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbZDGUjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbZDGUjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbZDGUjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:39:31 -0400
Received: from mailfe05.tele2.it ([212.247.154.141]:51178 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752786AbZDGUja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:39:30 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Apr 2009 16:39:30 EDT
X-Cloudmark-Score: 0.000000 []
X-Cloudmark-Analysis: v=1.0 c=1 a=gTSgHfSoPMgA:10 a=WEZlaz5u_NcA:10 a=8hWvghSQAAAA:8 a=i3dBniZaX_s5fkRFNy4A:9 a=ut7B469KWZMQuGnG2voA:7 a=2aeDbn_x8FWsf6A1nBDGQkLOvQcA:4 a=RMBU5szJeCoA:10
Message-ID: <49DBABD4.4020403@gmail.com>
Date: Tue, 07 Apr 2009 21:39:00 +0200
From: Massimo Maiurana <maiurana@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: kconfig: update-po-config broken in 2.6.29
References: <49DBA1E4.8000502@gmail.com> <20090407191741.GA13838@uranus.ravnborg.org>
In-Reply-To: <20090407191741.GA13838@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.6
OpenPGP: id=7044D601
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg, il 07/04/2009 21:17, scrisse:
> On Tue, Apr 07, 2009 at 08:56:36PM +0200, Massimo Maiurana wrote:
>> hi,
>> in latest 2.6.29 "make update-po-config" fails at msguniq invocation 
>> with an "invalid control sequence" error.
>> the offending string is the following, and it's located in 
>> drivers/staging/panel/Kconfig:72:
>> "'\e[L' which are specific to the LCD, and a few ANSI codes. The"
>>
>> looks to me like gettext expects strings in printf format, so in 
>> this case it thinks "\e" is a control sequence but doesn't recognise 
>> it as a valid one.
>>
>> I can still obtain a suitable linux.pot file escaping the backslash, 
>> and the resulting linux.mo file works even if the string is again 
>> unescaped, but of course if I leave the escaped string it will be 
>> displayed as-is (with a double backslash) if i run a configurator in 
>> english, so it is not a valid solution for a patch.
>>
>> Maybe a valid solution would be to tell kxgettext to automatically 
>> escape this kind of strings in the */config.pot he produces, so that 
>> msguniq would not complain?... I don't really know, and I don't even 
>> know how to do it. I see there is an escape function right at the 
>> top of kxgettext.c, but as I'm not a coder I don't really know how 
>> to hack it, so it's up to you... sorry.
> Seems like a simple solution - thank for analyzing it!
> 
> Could you try following (untested) patch and see if that works
> for you.
> 
> Thanks,
> 	Sam
> 
> diff --git a/scripts/kconfig/kxgettext.c b/scripts/kconfig/kxgettext.c
> index 6eb72a7..8d9ce22 100644
> --- a/scripts/kconfig/kxgettext.c
> +++ b/scripts/kconfig/kxgettext.c
> @@ -43,6 +43,10 @@ static char *escape(const char* text, char *bf, int len)
>  			++text;
>  			goto next;
>  		}
> +		else if (*text == '\\') {
> +			*bfp++ = '\\';
> +			len--;
> +		}
>  		*bfp++ = *text++;
>  next:
>  		--len;
> 

yes, your patch works as it should, i.e. the backslash get escaped 
and msguniq doesn't say a word :)

many thanks, sam.

-- 
       Massimo Maiurana         massimo<at>ragusa.linux.it
       http://massimo.solira.org       GPG keyID #7044D601

Articolo 33 - [...]Enti e privati hanno il diritto di istituire
scuole ed istituti di educazione, senza oneri per lo Stato.[...]
