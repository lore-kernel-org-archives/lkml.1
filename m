Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbXCKKKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbXCKKKu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 06:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXCKKKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 06:10:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:22789 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbXCKKKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 06:10:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=RJF6Y+T+Lo6BRFyVBDlXx8IvxHEG18gzrCehiTy33NxctvuTRUt04UFaV+BnpxUzowtxrmrMyEsBGiugX0SNwluKo5CuGm8l/uH52Tk86coXQ7dPQMWkOkXrzbYQzmbb4C3jB8ZN45xkBBUeGfoO1Yq7e31HP7MKwYodMU6UMV0=
Date: Sun, 11 Mar 2007 13:07:23 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
Message-ID: <20070311100723.GA10359@cvg>
References: <20070310160542.21cdb968@localhost> <20070310160614.GB10230@cvg> <Pine.LNX.4.61.0703101724160.8799@yvahk01.tjqt.qr> <20070310194617.2aef1006@localhost> <Pine.LNX.4.61.0703101747530.8799@yvahk01.tjqt.qr> <20070310175058.GA19878@cvg> <Pine.LNX.4.61.0703101906070.8799@yvahk01.tjqt.qr> <20070310212730.GA2577@uranus.ravnborg.org> <Pine.LNX.4.61.0703102234210.26332@yvahk01.tjqt.qr> <20070310224534.GA3150@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20070310224534.GA3150@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[Sam Ravnborg - Sat, Mar 10, 2007 at 11:45:34PM +0100]
| On Sat, Mar 10, 2007 at 10:34:41PM +0100, Jan Engelhardt wrote:
| > 
| > On Mar 10 2007 22:27, Sam Ravnborg wrote:
| > >On Sat, Mar 10, 2007 at 07:23:41PM +0100, Jan Engelhardt wrote:
| > >> 
| > >> Whether the 'working config file path' should change when you do
| > >> 'Save as Alternate' or not, is a menuconfig axiom. Ask Sam Ravnborg
| > >> if you want it changed :-)
| > >
| > >Current behaviour is not logical but on the other hand I do not
| > >see a big need to make it so.
| > >It seems that people very seldom uses "save alternate" anyway.
| > >
| > >But patches are welcome.
| > 
| > ^_^ The patch has already been posted, has not it?
| No.
| Either we keep current behaviour or we change to the "normal"
| behaviour with a "Save as..." as know from all other programs.
| 
| 	Sam
| 

Hi Sam,

here is a patch for menuconfig that shows current configuration
file. So I think menuconfig does its work well but the only
thing we need is to show location of an _active_ configuration.

Any comments are welcome (and you may swear at me too :)

		Cyrill


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mconf-new-behaviour-v001.diff"

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 3f9a132..cde6792 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -602,6 +602,12 @@ static void conf(struct menu *menu)
 			item_set_tag('L');
 			item_make(_("    Save an Alternate Configuration File"));
 			item_set_tag('S');
+			item_make("--- ");
+			item_set_tag(':');
+			item_make(_("    Current Configuration File: "));
+			item_set_tag(':');
+			item_add_str("%s", filename);
+
 		}
 		dialog_clear();
 		res = dialog_menu(prompt ? prompt : _("Main Menu"),
@@ -816,8 +822,11 @@ static void conf_load(void)
 		case 0:
 			if (!dialog_input_result[0])
 				return;
-			if (!conf_read(dialog_input_result))
+			if (!conf_read(dialog_input_result)) {
+				memset(filename, 0x0, PATH_MAX+1);
+				strncpy(filename, dialog_input_result, PATH_MAX);
 				return;
+			}
 			show_textbox(NULL, _("File does not exist!"), 5, 38);
 			break;
 		case 1:
@@ -840,8 +849,11 @@ static void conf_save(void)
 		case 0:
 			if (!dialog_input_result[0])
 				return;
-			if (!conf_write(dialog_input_result))
+			if (!conf_write(dialog_input_result)) {
+				memset(filename, 0x0, PATH_MAX+1);
+				strncpy(filename, dialog_input_result, PATH_MAX);
 				return;
+			}
 			show_textbox(NULL, _("Can't create file!  Probably a nonexistent directory."), 5, 60);
 			break;
 		case 1:
@@ -903,7 +915,7 @@ int main(int ac, char **av)
 
 	switch (res) {
 	case 0:
-		if (conf_write(NULL)) {
+		if (conf_write(filename)) {
 			fprintf(stderr, _("\n\n"
 				"Error during writing of the kernel configuration.\n"
 				"Your kernel configuration changes were NOT saved."

--3V7upXqbjpZ4EhLz--
