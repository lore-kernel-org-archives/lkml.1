Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbYIHWLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbYIHWLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 18:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbYIHWLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 18:11:44 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:56051 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672AbYIHWLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 18:11:43 -0400
Date: Tue, 9 Sep 2008 00:11:39 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHSCRIPT] MAINTAINERS: sort and merge P and M fields
Message-ID: <20080908221139.GA10991@cassiopeia.tralala>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello Linus,

some time ago I sent two patch scripts to LKML that changed the
MAINTAINERS file.  One fixed the alphabetic ordering and another merged
the P and M fields to ease copy'n'paste.

See
	http://thread.gmane.org/gmane.linux.kernel/702194
for the details.

I still like both changes, but I think it's not sensible to send you the
resulting patches because MAINTAINERS changes frequently.

If you like these two changes, too, I would be happy if you run the
attached script in your working copy.  It simply wraps the two scripts
and commits the changes.

Note that you need to apply the patch below before the scripts will
work.  And note further that the script expects a clean working copy to
start with, because it uses git commit -a.

Best regards
Uwe

---->8----
From: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
Subject: [PATCH] Fix format of MAINTAINERS

... one entry lacked a colon which broke one of my scripts.

Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index af27945..b3e92fb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1593,7 +1593,7 @@ S:	Supported
 EMBEDDED LINUX
 P:	Paul Gortmaker
 M:	paul.gortmaker@windriver.com
-P	David Woodhouse
+P:	David Woodhouse
 M:	dwmw2@infradead.org
 L:	linux-embedded@vger.kernel.org
 S:	Maintained
-- 
1.5.6.5


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=maintainers
Content-Transfer-Encoding: 8bit

#! /usr/bin/env python
# vim: set fileencoding=utf-8 :

import locale
import os

locale.setlocale(locale.LC_ALL, 'en_US.UTF-8')

author = 'Uwe Kleine-KÃ¶nig'
author_email = 'ukleinek@informatik.uni-freiburg.de'

script_sort = r"""#! /usr/bin/env python

import locale
import re
import sys
import tempfile

locale.setlocale(locale.LC_ALL, 'en_US.UTF-8')

re_start = re.compile('P:')
re_topic = re.compile('[0-9a-zA-Z][^:]')
# F is undefined but used
re_field = re.compile('[PMLWTSF]:')
re_empty = re.compile('\s*$')

prologue = True
current_topic = None
topic = dict()
fixed_maintainers = tempfile.TemporaryFile()

for line in open('MAINTAINERS'):
    if prologue:
        print >> fixed_maintainers, line,
        mo = re_start.match(line)
        if mo:
            prologue = False

        continue

    mo = re_topic.match(line)
    if mo:
        current_topic = line
        if topic.has_key(current_topic):
            sys.exit(1)
        topic[current_topic] = list()
        continue

    elif current_topic is None:
        # rest of prologue
        print >> fixed_maintainers, line,

        continue

    assert not current_topic is None

    mo = re_field.match(line)
    if mo:
        topic[current_topic].append(line)

    else:
        mo = re_empty.match(line)
        if not mo:
            print >> sys.stderr, 'tralala', current_topic, repr(line)
            sys.exit(1)

first = True

the_rest = 'THE REST\n'
have_the_rest = False

# sort case insensitive
for t, body in sorted(topic.iteritems(), key=lambda i: i[0].upper()):
    if t == the_rest:
        have_the_rest = True
        continue

    if first:
        first = False
    else:
        print >> fixed_maintainers

    print >> fixed_maintainers, t,
    for line in body:
        print >> fixed_maintainers, line,

if have_the_rest:
    print >> fixed_maintainers

    print >> fixed_maintainers, the_rest,
    for line in topic[the_rest]:
        print >> fixed_maintainers, line,

fixed_maintainers.seek(0)

maintainers = open('MAINTAINERS', 'w')
for line in fixed_maintainers:
    print >> maintainers, line,
"""

script_mergePM = r"""#! /usr/bin/env python

import locale
import re
import sys
import tempfile

locale.setlocale(locale.LC_ALL, 'en_US.UTF-8')

re_person = re.compile('P:(\s*)(.*)')
re_mail = re.compile('M:\s*(.*)')

fixed_maintainers = tempfile.TemporaryFile()

current_person = None
current_person_used = False

for lineno, line in enumerate(open('MAINTAINERS')):
    mo = re_person.match(line)
    if mo:
        if current_person and not current_person_used:
            print >> fixed_maintainers, 'P:%s%s' % (current_person_intend, current_person)

        current_person = mo.group(2)
        current_person_intend = mo.group(1)
        current_person_used = False
        continue

    mo = re_mail.match(line)
    if mo:
        if current_person is None:
            print 'mail without person at line %d' % (lineno + 1)
            sys.exit(1)

        mail = mo.group(1)

        if mail == 'Mail patches to':
            mail = 'p.e@rs.on'

        print >> fixed_maintainers, 'P:%s%s <%s>' % (current_person_intend, current_person, mail)
        current_person_used = True

    else:
        if current_person and not current_person_used:
            # either there is no mail address or the entry is already correct
            print >> fixed_maintainers, 'P:%s%s' % (current_person_intend, current_person)

        current_person = None
        print >> fixed_maintainers, line,

fixed_maintainers.seek(0)

maintainers = open('MAINTAINERS', 'w')
for line in fixed_maintainers:
    print >> maintainers, line,
"""

def tabintend(s):
    lines = s.split('\n')
    indented_lines = ('\t%s' % l for l in lines)
    return '\n'.join(indented_lines)

intended_script_sort = tabintend(script_sort)
intended_script_mergePM = tabintend(script_mergePM)

exec script_sort in dict(globals())

os.system('git commit --author="%(author)s <%(author_email)s>" -a -m "MAINTAINERS: fix alphabetic ordering\n\nThis change was done using the following Python script:\n\n%(intended_script_sort)s\n\nSigned-off-by: %(author)s <%(author_email)s>\n"' % locals())

exec script_mergePM in dict(globals())

os.system('git commit --author="%(author)s <%(author_email)s>" -a -m "MAINTAINERS: merge P and M fields to ease copy\'n\'paste\n\nThis was suggested by Sam Ravnborg and done using the following\nPython script:\n\n%(intended_script_mergePM)s\n\nSigned-off-by: %(author)s <%(author_email)s>\n"' % locals())

--EVF5PPMfhYS0aIcm--
