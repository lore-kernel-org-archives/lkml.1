Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbZDGTPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbZDGTPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZDGTPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:15:38 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:48759 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbZDGTPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:15:38 -0400
Date: Tue, 7 Apr 2009 21:17:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Massimo Maiurana <maiurana@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kconfig: update-po-config broken in 2.6.29
Message-ID: <20090407191741.GA13838@uranus.ravnborg.org>
References: <49DBA1E4.8000502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DBA1E4.8000502@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 08:56:36PM +0200, Massimo Maiurana wrote:
> hi,
> in latest 2.6.29 "make update-po-config" fails at msguniq invocation 
> with an "invalid control sequence" error.
> the offending string is the following, and it's located in 
> drivers/staging/panel/Kconfig:72:
> "'\e[L' which are specific to the LCD, and a few ANSI codes. The"
> 
> looks to me like gettext expects strings in printf format, so in 
> this case it thinks "\e" is a control sequence but doesn't recognise 
> it as a valid one.
> 
> I can still obtain a suitable linux.pot file escaping the backslash, 
> and the resulting linux.mo file works even if the string is again 
> unescaped, but of course if I leave the escaped string it will be 
> displayed as-is (with a double backslash) if i run a configurator in 
> english, so it is not a valid solution for a patch.
> 
> Maybe a valid solution would be to tell kxgettext to automatically 
> escape this kind of strings in the */config.pot he produces, so that 
> msguniq would not complain?... I don't really know, and I don't even 
> know how to do it. I see there is an escape function right at the 
> top of kxgettext.c, but as I'm not a coder I don't really know how 
> to hack it, so it's up to you... sorry.
Seems like a simple solution - thank for analyzing it!

Could you try following (untested) patch and see if that works
for you.

Thanks,
	Sam

diff --git a/scripts/kconfig/kxgettext.c b/scripts/kconfig/kxgettext.c
index 6eb72a7..8d9ce22 100644
--- a/scripts/kconfig/kxgettext.c
+++ b/scripts/kconfig/kxgettext.c
@@ -43,6 +43,10 @@ static char *escape(const char* text, char *bf, int len)
 			++text;
 			goto next;
 		}
+		else if (*text == '\\') {
+			*bfp++ = '\\';
+			len--;
+		}
 		*bfp++ = *text++;
 next:
 		--len;
