Return-Path: <linux-kernel-owner+w=401wt.eu-S1763101AbZBDTBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763101AbZBDTBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759508AbZBDStf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:35 -0500
Received: from kroah.org ([198.145.64.141]:32835 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761367AbZBDStZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:25 -0500
Date: Wed, 4 Feb 2009 10:46:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Len Brown <len.brown@intel.com>,
       Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Thomas Renninger <trenn@suse.de>
Subject: [patch 26/41] ACPICA: Fixed a couple memory leaks associated with
	"implicit return"
Message-ID: <20090204184640.GA25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpica-fixed-a-couple-memory-leaks-associated-with-implicit-return.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lin Ming <ming.m.lin@intel.com>

commit d8a0ec914afa1a994d2f6184ac4c6668b5f8068f upstream

Fixed a couple memory leaks associated with "implicit return" objects
when the AML Interpreter slack mode is enabled.

http://www.acpica.org/bugzilla/show_bug.cgi?id=349

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/dispatcher/dsmethod.c |    3 +++
 drivers/acpi/parser/psparse.c      |    4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/acpi/dispatcher/dsmethod.c
+++ b/drivers/acpi/dispatcher/dsmethod.c
@@ -103,6 +103,9 @@ acpi_ds_method_error(acpi_status status,
 						    NULL);
 		acpi_ex_enter_interpreter();
 	}
+
+	acpi_ds_clear_implicit_return(walk_state);
+
 #ifdef ACPI_DISASSEMBLER
 	if (ACPI_FAILURE(status)) {
 
--- a/drivers/acpi/parser/psparse.c
+++ b/drivers/acpi/parser/psparse.c
@@ -641,10 +641,12 @@ acpi_status acpi_ps_parse_aml(struct acp
 					    ACPI_WALK_METHOD_RESTART;
 				}
 			} else {
-				/* On error, delete any return object */
+				/* On error, delete any return object or implicit return */
 
 				acpi_ut_remove_reference(previous_walk_state->
 							 return_desc);
+				acpi_ds_clear_implicit_return
+				    (previous_walk_state);
 			}
 		}
 

