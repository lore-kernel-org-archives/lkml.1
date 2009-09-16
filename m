Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbZIPGs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbZIPGs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 02:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbZIPGs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 02:48:56 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:45851 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbZIPGsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 02:48:55 -0400
Date: Wed, 16 Sep 2009 15:48:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Paulo Marques <pmarques@grupopie.com>
Subject: Re: [PATCH] kallsyms: Fix segfault in prefix_underscores_count().
Message-ID: <20090916064840.GC5805@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Li Zefan <lizf@cn.fujitsu.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, Paulo Marques <pmarques@grupopie.com>
References: <20090916050845.GA5805@linux-sh.org> <4AB085A6.8000605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB085A6.8000605@cn.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 02:28:54PM +0800, Li Zefan wrote:
> Paul Mundt wrote:
> > Commit b478b782e110fdb4135caa3062b6d687e989d994 "kallsyms, tracing:
> > output more proper symbol name" introduces a "bugfix" that introduces
> > a segfault in kallsyms in my configurations.
> > 
> > The cause is the introduction of prefix_underscores_count() which
> > attempts to count underscores, even in symbols that do not have them.
> > As a result, it just uselessly runs past the end of the buffer until it
> > crashes:
> > 
> 
> But the fix looks obviously correct, as long as @str is guaranteed
> to be NULL-terminated.
> 
> ...
> > @@ -584,9 +538,14 @@ static int may_be_linker_script_provide_symbol(const struct sym_entry *se)
> >  static int prefix_underscores_count(const char *str)
> >  {
> >  	const char *tail = str;
> > +	size_t len = strlen(str);
> > +
> > +	while (*tail != '_') {
> > +		if (!len--)
> > +			return 0;
> >  
> > -	while (*tail != '_')
> >  		tail++;
> > +	}
> 
> Can be simplified as:
> 
> 	while (*tail != '\0' && *tail != '_')
> 		tail++;
> 
> But..as the name "prefix_underscores_count" suggests, shouldn't
> it be:
> 	while (*tail == '_')
> 		tail++;
> ??
> 
Yes, that was what I did initially as well, but the behaviour is not
exactly the same, and I wanted an explanation from Lai if there were some
other intentions for the code. In any event, simplifying it still manages
to do the right thing, so I'm fine with that.

------------------------
Subject: [PATCH] kallsyms: Fix segfault in prefix_underscores_count().

Commit b478b782e110fdb4135caa3062b6d687e989d994 "kallsyms, tracing:
output more proper symbol name" introduces a "bugfix" that introduces
a segfault in kallsyms in my configurations.

The cause is the introduction of prefix_underscores_count() which
attempts to count underscores, even in symbols that do not have them.
As a result, it just uselessly runs past the end of the buffer until it
crashes:

  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
  KSYM    .tmp_kallsyms1.S
/bin/sh: line 1: 16934 Done                    sh-linux-gnu-nm -n .tmp_vmlinux1
     16935 Segmentation fault      | scripts/kallsyms > .tmp_kallsyms1.S
make: *** [.tmp_kallsyms1.S] Error 139

This simplifies the logic and just does a straightforward count.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 scripts/kallsyms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 64343cc..86c3896 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -585,7 +585,7 @@ static int prefix_underscores_count(const char *str)
 {
 	const char *tail = str;
 
-	while (*tail != '_')
+	while (*tail == '_')
 		tail++;
 
 	return tail - str;
